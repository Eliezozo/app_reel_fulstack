import express from 'express';
import { readFile } from 'node:fs/promises';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import {
  loginAccount,
  logoutSession,
  readProfile,
  refreshSession,
  registerAccount,
  requireAuth,
  seedDemoUser,
} from './accounts.js';
import { getWeather } from './weather.js';

const dataDir = join(dirname(fileURLToPath(import.meta.url)), '..', 'data');
const port = Number(process.env.PORT ?? 8787);

const markets = JSON.parse(await readFile(join(dataDir, 'markets.json'), 'utf8'));
const news = JSON.parse(await readFile(join(dataDir, 'news.json'), 'utf8'));

function asyncRoute(handler) {
  return (req, res, next) => {
    Promise.resolve(handler(req, res)).catch(next);
  };
}

function findById(items, id) {
  return items.find((item) => item.id === id);
}

const app = express();
app.disable('x-powered-by');
app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Headers', 'Authorization, Content-Type');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  if (req.method === 'OPTIONS') {
    res.sendStatus(204);
    return;
  }
  next();
});
app.use(express.json({ limit: '1mb' }));

app.get('/api/health', (_req, res) => {
  res.json({ status: 'ok', service: 'agriboard' });
});

app.post('/api/auth/register', asyncRoute(async (req, res) => {
  res.status(201).json(await registerAccount(req.body));
}));

app.post('/api/auth/login', asyncRoute(async (req, res) => {
  res.json(await loginAccount(req.body));
}));

app.post('/api/auth/refresh', asyncRoute(async (req, res) => {
  res.json(await refreshSession(req.body));
}));

app.post('/api/auth/logout', requireAuth, asyncRoute(async (req, res) => {
  await logoutSession(req.body);
  res.status(204).send();
}));

app.get('/api/auth/me', requireAuth, (req, res) => {
  res.json(readProfile(req.user));
});

app.get('/api/markets', requireAuth, (_req, res) => {
  res.json({ data: markets });
});

app.get('/api/markets/:id', requireAuth, (req, res) => {
  const market = findById(markets, req.params.id);
  if (market == null) {
    res.status(404).json({ message: 'Prix introuvable.' });
    return;
  }
  res.json({ data: market });
});

app.get('/api/weather', requireAuth, asyncRoute(async (_req, res) => {
  res.json({ data: await getWeather() });
}));

app.get('/api/news', requireAuth, (_req, res) => {
  res.json({ data: news });
});

app.get('/api/news/:id', requireAuth, (req, res) => {
  const article = findById(news, req.params.id);
  if (article == null) {
    res.status(404).json({ message: 'Bulletin introuvable.' });
    return;
  }
  res.json({ data: article });
});

app.use((error, _req, res, _next) => {
  const status = typeof error.status === 'number' ? error.status : 500;
  const message = status === 500
    ? 'Le serveur a un problème. Réessaie dans un moment.'
    : error.message;
  if (status === 500) {
    console.error(error);
  }
  res.status(status).json({ message });
});

await seedDemoUser();

app.listen(port, '0.0.0.0', () => {
  console.log(`AgriBoard API sur http://localhost:${port}`);
});

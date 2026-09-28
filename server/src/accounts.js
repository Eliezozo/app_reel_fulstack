import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { createHash, randomUUID } from 'node:crypto';
import { mkdir, readFile, writeFile } from 'node:fs/promises';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const dataDir = join(dirname(fileURLToPath(import.meta.url)), '..', 'data');

const JWT_SECRET = process.env.JWT_SECRET ?? 'dev-only-change-me';
const ACCESS_TTL = process.env.ACCESS_TTL ?? '15m';
const REFRESH_TTL = process.env.REFRESH_TTL ?? '7d';

const DEMO_USER = {
  name: 'Ama Koffi',
  email: 'demo@agriboard.tg',
  password: 'demo1234',
};

let writeQueue = Promise.resolve();

function withLock(task) {
  const run = writeQueue.then(() => task());
  writeQueue = run.then(
    () => undefined,
    () => undefined,
  );
  return run;
}

function httpError(status, message) {
  const error = new Error(message);
  error.status = status;
  return error;
}

function hashToken(token) {
  return createHash('sha256').update(token).digest('hex');
}

async function readJson(name, fallback) {
  try {
    const raw = await readFile(join(dataDir, name), 'utf8');
    return JSON.parse(raw);
  } catch {
    return fallback;
  }
}

async function writeJson(name, value) {
  await mkdir(dataDir, { recursive: true });
  await writeFile(join(dataDir, name), `${JSON.stringify(value, null, 2)}\n`);
}

function publicUser(user) {
  return { id: user.id, name: user.name, email: user.email };
}

function signAccess(user) {
  return jwt.sign(
    { sub: user.id, email: user.email, name: user.name, type: 'access' },
    JWT_SECRET,
    { expiresIn: ACCESS_TTL },
  );
}

function signRefresh(user) {
  return jwt.sign(
    { sub: user.id, type: 'refresh', jti: randomUUID() },
    JWT_SECRET,
    { expiresIn: REFRESH_TTL },
  );
}

async function persistRefresh(userId, refreshToken) {
  const decoded = jwt.decode(refreshToken);
  const store = await readJson('refresh-tokens.json', { tokens: {} });
  store.tokens[hashToken(refreshToken)] = {
    userId,
    exp: decoded?.exp ?? 0,
  };
  await writeJson('refresh-tokens.json', store);
}

async function issueSession(user) {
  const accessToken = signAccess(user);
  const refreshToken = signRefresh(user);
  await persistRefresh(user.id, refreshToken);
  return {
    user: publicUser(user),
    accessToken,
    refreshToken,
  };
}

function assertString(body, field) {
  if (body == null || typeof body !== 'object') {
    throw httpError(400, 'Requête invalide.');
  }
  const value = body[field];
  if (typeof value !== 'string' || value.trim().length === 0) {
    throw httpError(400, 'Merci de remplir tous les champs.');
  }
  return value.trim();
}

function assertEmail(email) {
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    throw httpError(400, 'Adresse email invalide.');
  }
  return email.toLowerCase();
}

export function requireAuth(req, res, next) {
  const header = req.headers.authorization ?? '';
  const [scheme, token] = header.split(' ');
  if (scheme !== 'Bearer' || token == null || token.length === 0) {
    res.status(401).json({ message: 'Session expirée. Reconnecte-toi.' });
    return;
  }
  try {
    const payload = jwt.verify(token, JWT_SECRET);
    if (payload.type !== 'access' || typeof payload.sub !== 'string') {
      res.status(401).json({ message: 'Session expirée. Reconnecte-toi.' });
      return;
    }
    req.user = {
      id: payload.sub,
      email: payload.email,
      name: payload.name,
    };
    next();
  } catch {
    res.status(401).json({ message: 'Session expirée. Reconnecte-toi.' });
  }
}

export async function seedDemoUser() {
  await withLock(async () => {
    const db = await readJson('users.json', { users: [] });
    const exists = db.users.some((user) => user.email === DEMO_USER.email);
    if (exists) return;
    db.users.push({
      id: randomUUID(),
      name: DEMO_USER.name,
      email: DEMO_USER.email,
      passwordHash: await bcrypt.hash(DEMO_USER.password, 10),
    });
    await writeJson('users.json', db);
  });
}

export async function registerAccount(body) {
  const name = assertString(body, 'name');
  const email = assertEmail(assertString(body, 'email'));
  const password = assertString(body, 'password');
  if (name.length < 2) {
    throw httpError(400, 'Le nom doit contenir au moins 2 caractères.');
  }
  if (password.length < 6) {
    throw httpError(400, 'Le mot de passe doit contenir au moins 6 caractères.');
  }

  return withLock(async () => {
    const db = await readJson('users.json', { users: [] });
    if (db.users.some((user) => user.email === email)) {
      throw httpError(409, 'Cet email est déjà utilisé.');
    }
    const user = {
      id: randomUUID(),
      name,
      email,
      passwordHash: await bcrypt.hash(password, 10),
    };
    db.users.push(user);
    await writeJson('users.json', db);
    return issueSession(user);
  });
}

export async function loginAccount(body) {
  const email = assertEmail(assertString(body, 'email'));
  const password = assertString(body, 'password');

  return withLock(async () => {
    const db = await readJson('users.json', { users: [] });
    const user = db.users.find((item) => item.email === email);
    const matches = user == null ? false : await bcrypt.compare(password, user.passwordHash);
    if (user == null || !matches) {
      throw httpError(401, 'Email ou mot de passe incorrect.');
    }
    return issueSession(user);
  });
}

export async function refreshSession(body) {
  const refreshToken = body == null ? '' : body.refreshToken;
  if (typeof refreshToken !== 'string' || refreshToken.length === 0) {
    throw httpError(401, 'Session expirée. Reconnecte-toi.');
  }

  return withLock(async () => {
    let payload;
    try {
      payload = jwt.verify(refreshToken, JWT_SECRET);
    } catch {
      throw httpError(401, 'Session expirée. Reconnecte-toi.');
    }
    if (payload.type !== 'refresh' || typeof payload.sub !== 'string') {
      throw httpError(401, 'Session expirée. Reconnecte-toi.');
    }

    const store = await readJson('refresh-tokens.json', { tokens: {} });
    const key = hashToken(refreshToken);
    const saved = store.tokens[key];
    if (saved == null || saved.userId !== payload.sub) {
      throw httpError(401, 'Session expirée. Reconnecte-toi.');
    }
    delete store.tokens[key];
    await writeJson('refresh-tokens.json', store);

    const db = await readJson('users.json', { users: [] });
    const user = db.users.find((item) => item.id === payload.sub);
    if (user == null) {
      throw httpError(401, 'Session expirée. Reconnecte-toi.');
    }
    return issueSession(user);
  });
}

export async function logoutSession(body) {
  const refreshToken = body == null ? '' : body.refreshToken;
  if (typeof refreshToken !== 'string' || refreshToken.length === 0) return;
  await withLock(async () => {
    const store = await readJson('refresh-tokens.json', { tokens: {} });
    delete store.tokens[hashToken(refreshToken)];
    await writeJson('refresh-tokens.json', store);
  });
}

export function readProfile(user) {
  return { user: { id: user.id, name: user.name, email: user.email } };
}

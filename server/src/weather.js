const CITIES = [
  { id: 'lome', city: 'Lomé', region: 'Maritime', latitude: 6.1725, longitude: 1.2314, temp: 28.5 },
  { id: 'kara', city: 'Kara', region: 'Kara', latitude: 9.5511, longitude: 1.1861, temp: 30.2 },
  { id: 'sokode', city: 'Sokodé', region: 'Centrale', latitude: 8.9833, longitude: 1.1333, temp: 29.4 },
  { id: 'atakpame', city: 'Atakpamé', region: 'Plateaux', latitude: 7.5333, longitude: 1.1333, temp: 27.8 },
  { id: 'kpalime', city: 'Kpalimé', region: 'Plateaux', latitude: 6.9, longitude: 0.6333, temp: 26.6 },
  { id: 'dapaong', city: 'Dapaong', region: 'Savanes', latitude: 10.8623, longitude: 0.2076, temp: 32.1 },
];

let memoryCache = { at: 0, data: null };
const cacheTtlMs = 10 * 60 * 1000;

function describe(code) {
  if (code === 0) return 'Ciel dégagé';
  if (code <= 3) return 'Nuageux';
  if (code <= 48) return 'Brouillard';
  if (code <= 57) return 'Bruine';
  if (code <= 67) return 'Pluie';
  if (code <= 77) return 'Neige';
  if (code <= 82) return 'Averses';
  return 'Orage';
}

function round1(value) {
  const number = typeof value === 'number' && Number.isFinite(value) ? value : 0;
  return Math.round(number * 10) / 10;
}

function upcomingDates(count) {
  const dates = [];
  const start = new Date();
  for (let index = 0; index < count; index += 1) {
    const day = new Date(start);
    day.setDate(start.getDate() + index);
    dates.push(day.toISOString().slice(0, 10));
  }
  return dates;
}

function fallbackCity(city) {
  const dates = upcomingDates(5);
  return {
    id: city.id,
    city: city.city,
    region: city.region,
    temperature: city.temp,
    humidity: 70,
    windSpeed: 8,
    weatherCode: 2,
    description: 'Nuageux',
    precipitation: 0,
    estimated: true,
    daily: dates.map((date, index) => ({
      date,
      tempMin: round1(city.temp - 4),
      tempMax: round1(city.temp + 2 + index * 0.2),
      weatherCode: 2,
      precipitation: 0,
    })),
  };
}

function mapLive(city, payload) {
  const current = payload.current ?? {};
  const daily = payload.daily ?? {};
  const dates = Array.isArray(daily.time) ? daily.time : [];
  const weatherCode = Math.round(current.weather_code ?? 0);
  return {
    id: city.id,
    city: city.city,
    region: city.region,
    temperature: round1(current.temperature_2m),
    humidity: Math.round(current.relative_humidity_2m ?? 0),
    windSpeed: round1(current.wind_speed_10m),
    weatherCode,
    description: describe(weatherCode),
    precipitation: round1(current.precipitation),
    estimated: false,
    daily: dates.map((date, index) => ({
      date,
      tempMin: round1(daily.temperature_2m_min?.[index]),
      tempMax: round1(daily.temperature_2m_max?.[index]),
      weatherCode: Math.round(daily.weather_code?.[index] ?? 0),
      precipitation: round1(daily.precipitation_sum?.[index]),
    })),
  };
}

async function loadCity(city) {
  const url = new URL('https://api.open-meteo.com/v1/forecast');
  url.searchParams.set('latitude', String(city.latitude));
  url.searchParams.set('longitude', String(city.longitude));
  url.searchParams.set(
    'current',
    'temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m,precipitation',
  );
  url.searchParams.set(
    'daily',
    'weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum',
  );
  url.searchParams.set('timezone', 'Africa/Lome');
  url.searchParams.set('forecast_days', '5');

  const response = await fetch(url, { signal: AbortSignal.timeout(8000) });
  if (!response.ok) {
    throw new Error(`Open-Meteo ${response.status}`);
  }
  const payload = await response.json();
  return mapLive(city, payload);
}

export async function getWeather() {
  if (memoryCache.data != null && Date.now() - memoryCache.at < cacheTtlMs) {
    return memoryCache.data;
  }

  const data = await Promise.all(
    CITIES.map(async (city) => {
      try {
        return await loadCity(city);
      } catch (error) {
        console.error(`Météo indisponible pour ${city.city}:`, error.message);
        return fallbackCity(city);
      }
    }),
  );
  memoryCache = { at: Date.now(), data };
  return data;
}

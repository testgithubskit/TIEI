/** Vite dev ports */
export const LOCAL_TNGA_PORT = '5173';
export const LOCAL_GD_PORT = '5174';

/** Docker / split-port production (TNGA :3051, GD :3052) */
export const PROD_TNGA_PORT = '3051';
export const PROD_GD_PORT = '3052';

const PORT_PAIRS = [
  { TNGA: LOCAL_TNGA_PORT, GD: LOCAL_GD_PORT },
  { TNGA: PROD_TNGA_PORT, GD: PROD_GD_PORT },
];

export function plantFromSchema(schemaName) {
  if (schemaName === 'tiei_gd_plant_1') return 'GD';
  if (schemaName) return 'TNGA';
  if (typeof window !== 'undefined') {
    const path = window.location.pathname || '';
    const port = String(window.location.port || '');
    if (path.includes('tiei_dynamic_gd') || port === LOCAL_GD_PORT || port === PROD_GD_PORT) {
      return 'GD';
    }
  }
  return 'TNGA';
}

function currentPagePort() {
  if (typeof window === 'undefined') return '';
  return String(window.location.port || '');
}

/** Port for the target plant, or '' when the page is on 80/443 (path-only). */
function portForPlant(plantKey) {
  const current = currentPagePort();
  if (!current) return '';

  const pair = PORT_PAIRS.find((p) => p.TNGA === current || p.GD === current);
  if (pair) {
    return plantKey === 'GD' ? pair.GD : pair.TNGA;
  }
  return current;
}

/**
 * Full URL for the other (or same) plant frontend.
 * @param {'TNGA'|'GD'} plantKey
 * @param {string} hashPath e.g. '/managerialOverview' or '#/managerialOverview'
 */
export function buildPlantUrl(plantKey, hashPath) {
  const protocol = window.location.protocol || 'http:';
  const host = window.location.hostname || 'localhost';
  const appPath = plantKey === 'GD' ? '/tiei_dynamic_gd/' : '/tiei_dynamic/';
  const hash = hashPath.startsWith('#') ? hashPath : `#${hashPath}`;
  const port = portForPlant(plantKey);
  const portPart = port ? `:${port}` : '';
  return `${protocol}//${host}${portPart}${appPath}${hash}`;
}

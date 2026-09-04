/** Local Vite ports for the two plant apps. Production uses no extra port. */
export const LOCAL_TNGA_PORT = '5173';
export const LOCAL_GD_PORT = '5174';

export function plantFromSchema(schemaName) {
  if (schemaName === 'tiei_gd_plant_1') return 'GD';
  return 'TNGA';
}

function isLocalDev() {
  if (typeof window === 'undefined') return false;
  const port = String(window.location.port || '');
  return port === LOCAL_TNGA_PORT || port === LOCAL_GD_PORT;
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
  if (isLocalDev()) {
    const port = plantKey === 'GD' ? LOCAL_GD_PORT : LOCAL_TNGA_PORT;
    return `${protocol}//${host}:${port}${appPath}${hash}`;
  }
  return `${protocol}//${host}${appPath}${hash}`;
}

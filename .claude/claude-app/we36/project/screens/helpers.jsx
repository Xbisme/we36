/* We36 screen mockups — shared phone frame, status bar, chrome & sample data. */
const W36 = window.We36DesignSystem_f909ab;

/* ---------- navigation (no-op on the static canvas, live in the prototype) ---------- */
const NavCtx = React.createContext(null);
const NAV_NOOP = { go() {}, back() {}, tab() {}, reset() {}, toast() {} };
function useNav() { return React.useContext(NavCtx) || NAV_NOOP; }

/* ---------- sample imagery ---------- */
const IMG = {
  maya:   'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=200&fit=crop',
  devon:  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop',
  aisha:  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=200&fit=crop',
  liam:   'https://images.unsplash.com/photo-1463453091185-61582044d556?w=200&h=200&fit=crop',
  noor:   'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=200&h=200&fit=crop',
  kai:    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=200&fit=crop',
  sofia:  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=200&fit=crop',
};
const PHOTO = (id, w = 600, h = 600) => `https://images.unsplash.com/${id}?w=${w}&h=${h}&fit=crop`;
const GRID_IDS = [
  'photo-1504674900247-0877df9cc836','photo-1519681393784-d120267933ba','photo-1493246507139-91e8fad9978e',
  'photo-1418065460487-3e41a6c84dc5','photo-1469474968028-56623f02e42e','photo-1500534314209-a25ddb2bd429',
  'photo-1441974231531-c6227db76b6e','photo-1470770841072-f978cf4d019e','photo-1426604966848-d7adac402bff',
  'photo-1517363898874-737b62a7db91','photo-1513735492246-483525079686','photo-1542051841857-5f90071e7989',
];

/* ---------- iOS-style status bar ---------- */
function StatusBar({ light }) {
  const c = light ? '#fff' : 'var(--text-primary)';
  return (
    <div style={{ height: 44, flexShrink: 0, display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '0 22px 0 26px', fontFamily: 'var(--font-display)' }}>
      <span style={{ fontSize: 14, fontWeight: 700, color: c, letterSpacing: '-0.01em' }}>9:41</span>
      <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
        {/* signal */}
        <svg width="17" height="11" viewBox="0 0 17 11" fill="none"><rect x="0" y="7" width="3" height="4" rx="1" fill={c}/><rect x="4.5" y="5" width="3" height="6" rx="1" fill={c}/><rect x="9" y="2.5" width="3" height="8.5" rx="1" fill={c}/><rect x="13.5" y="0" width="3" height="11" rx="1" fill={c}/></svg>
        {/* wifi */}
        <svg width="16" height="11" viewBox="0 0 16 11" fill="none"><path d="M8 2.5c2.6 0 5 1 6.8 2.7l-1.4 1.4A7.6 7.6 0 0 0 8 4.4 7.6 7.6 0 0 0 2.6 6.6L1.2 5.2A9.6 9.6 0 0 1 8 2.5Z" fill={c}/><path d="M8 6c1.3 0 2.5.5 3.4 1.4L8 10.8 4.6 7.4A4.8 4.8 0 0 1 8 6Z" fill={c}/></svg>
        {/* battery */}
        <svg width="25" height="12" viewBox="0 0 25 12" fill="none"><rect x="0.5" y="0.5" width="21" height="11" rx="3" stroke={c} strokeOpacity="0.45"/><rect x="2" y="2" width="17" height="8" rx="1.5" fill={c}/><rect x="23" y="4" width="1.6" height="4" rx="0.8" fill={c} fillOpacity="0.5"/></svg>
      </div>
    </div>
  );
}

/* ---------- the phone frame each screen lives in ---------- */
function Frame({ children, bg = 'var(--surface)', dark, lightStatus, nav, noStatus }) {
  return (
    <div data-theme={dark ? 'dark' : 'light'} style={{ width: 390, height: 760, background: bg, display: 'flex', flexDirection: 'column', overflow: 'hidden', position: 'relative', fontFamily: 'var(--font-body)', color: 'var(--text-primary)' }}>
      {!noStatus && <StatusBar light={lightStatus || dark} />}
      <div className="frame-scroll" style={{ flex: 1, minHeight: 0, display: 'flex', flexDirection: 'column', overflowY: 'auto', overflowX: 'hidden' }}>{children}</div>
      {nav}
    </div>
  );
}

/* ---------- generic top app bar ---------- */
function TopBar({ title, back, action, large, onBack }) {
  const { Icon } = W36;
  const nav = useNav();
  return (
    <header style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '0 12px', height: 52, flexShrink: 0, background: 'var(--surface)', borderBottom: '1px solid var(--divider)' }}>
      {back && <span onClick={onBack || nav.back} style={{ cursor: 'pointer', display: 'flex', margin: '0 -4px', padding: 4 }}><Icon name="chevronLeft" size={26} color="var(--text-primary)" /></span>}
      <span style={{ fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: large ? 20 : 17, color: 'var(--text-primary)', marginLeft: back ? 0 : 4 }}>{title}</span>
      <div style={{ marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: 4 }}>{action}</div>
    </header>
  );
}

/* ---------- gradient wordmark ---------- */
function Wordmark({ size = 26, mono }) {
  return (
    <span style={{ fontFamily: 'var(--font-display)', fontWeight: 800, fontSize: size, letterSpacing: '-0.03em',
      ...(mono ? { color: '#fff' } : { background: 'var(--gradient-brand)', WebkitBackgroundClip: 'text', backgroundClip: 'text', color: 'transparent' }) }}>We36</span>
  );
}

Object.assign(window, { W36, IMG, PHOTO, GRID_IDS, StatusBar, Frame, TopBar, Wordmark, NavCtx, useNav });

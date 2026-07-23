/* We36 — System UI & overlays: sticker tray, toast, dialog, action sheet.
   These patterns aren't in the base component set — built on DS tokens here. */

/* ---------- sticker affordance glyph (Lucide-style smiley) ---------- */
function StickerGlyph({ size = 24, color = 'currentColor' }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="12" r="9.5" />
      <path d="M8.5 14.5s1.2 1.8 3.5 1.8 3.5-1.8 3.5-1.8" />
      <circle cx="9" cy="10" r="0.6" fill={color} stroke="none" />
      <circle cx="15" cy="10" r="0.6" fill={color} stroke="none" />
    </svg>
  );
}

/* ---------- sticker / emoji picker tray ---------- */
const STICKER_CATS = ['Recent', 'Smileys', 'Love', 'Gestures', 'Animals'];
const STICKERS = ['😍','😂','🔥','🙌','😭','✨','🥹','😎','🤩','😅','👏','💯','🌅','🌊','☀️','🦋','🍃','🌸','💜','❤️'];

function StickerTray({ onClose }) {
  const { Icon, SearchBar } = W36;
  return (
    <div style={{ flexShrink: 0, background: 'var(--surface)', borderTop: '1px solid var(--divider)', boxShadow: '0 -6px 20px rgba(26,26,46,.06)' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '10px 14px 6px' }}>
        <div style={{ flex: 1 }}><SearchBar placeholder="Search stickers" /></div>
        {onClose && <span onClick={onClose} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="x" size={20} color="var(--icon)" /></span>}
      </div>
      <div style={{ display: 'flex', gap: 8, padding: '4px 14px 10px', overflowX: 'hidden' }}>
        {STICKER_CATS.map((c, i) => (
          <span key={c} style={{ flexShrink: 0, padding: '6px 12px', borderRadius: 999, fontSize: 13, fontWeight: 600,
            background: i === 0 ? 'var(--gradient-brand)' : 'var(--surface-2)', color: i === 0 ? '#fff' : 'var(--text-secondary)' }}>{c}</span>
        ))}
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(5, 1fr)', gap: 6, padding: '0 12px 14px' }}>
        {STICKERS.map((s, i) => (
          <div key={i} onClick={onClose} style={{ cursor: 'pointer', aspectRatio: '1', borderRadius: 14, background: 'var(--surface-2)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 30 }}>{s}</div>
        ))}
      </div>
    </div>
  );
}

/* E2b · Chat with sticker tray open */
function StickerPickerScreen() {
  const { Avatar, Icon } = W36;
  const nav = useNav();
  const Bubble = ({ me, children, tail }) => (
    <div style={{ alignSelf: me ? 'flex-end' : 'flex-start', maxWidth: '74%', background: me ? 'var(--gradient-brand)' : 'var(--surface-2)', color: me ? '#fff' : 'var(--text-primary)', padding: '9px 14px', borderRadius: 20, borderBottomRightRadius: me && tail ? 6 : 20, borderBottomLeftRadius: !me && tail ? 6 : 20, fontSize: 14, lineHeight: '20px' }}>{children}</div>
  );
  return (
    <Frame bg="var(--surface)">
      <header style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '0 12px', height: 56, borderBottom: '1px solid var(--divider)', flexShrink: 0 }}>
        <span onClick={() => nav.go('chat')} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="chevronLeft" size={26} color="var(--text-primary)" /></span>
        <Avatar src={IMG.devon} size={36} online />
        <div><div style={{ fontSize: 15, fontWeight: 700 }}>devon.shoots</div><div style={{ fontSize: 12, color: 'var(--mint-500)' }}>Active now</div></div>
        <div style={{ marginLeft: 'auto', display: 'flex', gap: 14 }}><Icon name="camera" size={22} color="var(--icon)" /><Icon name="more" size={22} color="var(--icon)" /></div>
      </header>
      <div style={{ flex: 1, overflow: 'hidden', display: 'flex', flexDirection: 'column', gap: 6, padding: '14px 14px', justifyContent: 'flex-end' }}>
        <Bubble>hey! did the tokyo shots come out?</Bubble>
        <Bubble me tail>yeah they're unreal 🔥</Bubble>
        {/* a sent sticker */}
        <div style={{ alignSelf: 'flex-end', fontSize: 64, lineHeight: 1, padding: '2px 4px' }}>🤩</div>
      </div>
      {/* input with sticker active */}
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '8px 14px', flexShrink: 0 }}>
        <span style={{ width: 38, height: 38, borderRadius: '50%', background: 'var(--gradient-brand)', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}><Icon name="camera" size={20} color="#fff" /></span>
        <div style={{ flex: 1, height: 40, borderRadius: 999, background: 'var(--surface-2)', display: 'flex', alignItems: 'center', padding: '0 12px 0 16px', gap: 8 }}>
          <span style={{ flex: 1, color: 'var(--text-tertiary)', fontSize: 14 }}>Message…</span>
          <StickerGlyph size={22} color="var(--rose-500)" />
        </div>
      </div>
      <StickerTray onClose={() => nav.back()} />
    </Frame>
  );
}

/* ---------- TOAST ---------- */
function Toast({ tone = 'neutral', icon, children, action }) {
  const tints = {
    success: ['var(--mint-400)', 'check'],
    error:   ['var(--rose-500)', 'x'],
    info:    ['var(--violet-500)', 'notification'],
    neutral: ['var(--gray-400)', 'check'],
  };
  const [dot, ic] = tints[tone] || tints.neutral;
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 12, background: 'var(--ink)', color: '#fff', borderRadius: 14, padding: '12px 14px', boxShadow: '0 10px 30px rgba(26,26,46,.28)' }}>
      <span style={{ width: 28, height: 28, borderRadius: '50%', background: dot, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
        <W36.Icon name={icon || ic} size={16} color="#fff" />
      </span>
      <span style={{ flex: 1, fontSize: 14, fontWeight: 500, lineHeight: '18px' }}>{children}</span>
      {action && <span style={{ color: 'var(--rose-300)', fontWeight: 700, fontSize: 14, flexShrink: 0 }}>{action}</span>}
    </div>
  );
}

/* G1 · Toast in context (over feed) */
function ToastScreen() {
  const { PostCard, BottomNav } = W36;
  return (
    <Frame bg="var(--bg-app)" nav={<BottomNav active="home" onChange={()=>{}} badges={{ message: 3 }} />}>
      <div style={{ flex: 1, overflow: 'hidden', position: 'relative', padding: '12px 8px 0' }}>
        <PostCard user="maya.travels" avatar={IMG.maya} location="Lisbon, Portugal" image={PHOTO('photo-1513735492246-483525079686', 900, 1100)} likes={1240} caption="golden hour never misses ☀️" comments={86} time="2h" style={{ maxWidth: '100%' }} />
        <div style={{ position: 'absolute', left: 14, right: 14, bottom: 14 }}>
          <Toast tone="success" action="Undo">Saved to <b>travel</b> collection</Toast>
        </div>
      </div>
    </Frame>
  );
}

/* G2 · Toast variants (spec board) */
function ToastVariantsScreen() {
  return (
    <Frame bg="var(--bg-app)">
      <TopBar title="Toast" back large />
      <div style={{ flex: 1, overflow: 'hidden', padding: '18px 16px', display: 'flex', flexDirection: 'column', gap: 16 }}>
        <div><div style={{ fontSize: 12, fontWeight: 700, color: 'var(--text-tertiary)', textTransform: 'uppercase', letterSpacing: '.04em', marginBottom: 8 }}>Success</div><Toast tone="success">Your post was shared</Toast></div>
        <div><div style={{ fontSize: 12, fontWeight: 700, color: 'var(--text-tertiary)', textTransform: 'uppercase', letterSpacing: '.04em', marginBottom: 8 }}>With action</div><Toast tone="neutral" icon="save" action="Undo">Removed from saved</Toast></div>
        <div><div style={{ fontSize: 12, fontWeight: 700, color: 'var(--text-tertiary)', textTransform: 'uppercase', letterSpacing: '.04em', marginBottom: 8 }}>Info</div><Toast tone="info" icon="notification">New followers — tap to view</Toast></div>
        <div><div style={{ fontSize: 12, fontWeight: 700, color: 'var(--text-tertiary)', textTransform: 'uppercase', letterSpacing: '.04em', marginBottom: 8 }}>Error</div><Toast tone="error">Couldn't upload. Tap to retry</Toast></div>
      </div>
    </Frame>
  );
}

/* dim backdrop helper (a quiet post behind overlays) */
function DimBackdrop() {
  const { Avatar, Icon } = W36;
  return (
    <React.Fragment>
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '10px 14px' }}>
        <Avatar src={IMG.devon} size={36} />
        <span style={{ fontWeight: 700, fontSize: 14 }}>devon.shoots</span>
        <Icon name="more" size={20} color="var(--icon)" style={{ marginLeft: 'auto' }} />
      </div>
      <img src={PHOTO('photo-1542051841857-5f90071e7989', 800, 800)} alt="" style={{ width: '100%', aspectRatio: '1', objectFit: 'cover', display: 'block' }} />
      <div style={{ padding: '12px 14px' }}><div style={{ display: 'flex', gap: 16 }}><Icon name="like" size={26} color="var(--icon)" /><Icon name="comment" size={26} color="var(--icon)" /><Icon name="share" size={26} color="var(--icon)" /></div></div>
    </React.Fragment>
  );
}

/* ---------- DIALOG ---------- */
function Dialog({ title, body, cancel = 'Cancel', confirm, destructive, onCancel, onConfirm }) {
  const { Button } = W36;
  return (
    <div style={{ width: 300, background: 'var(--surface)', borderRadius: 20, overflow: 'hidden', boxShadow: '0 24px 60px rgba(26,26,46,.4)' }}>
      <div style={{ padding: '22px 22px 18px', textAlign: 'center' }}>
        <div style={{ fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 19 }}>{title}</div>
        {body && <div style={{ fontSize: 14, color: 'var(--text-secondary)', lineHeight: '20px', marginTop: 8 }}>{body}</div>}
      </div>
      <div style={{ display: 'flex', gap: 10, padding: '0 18px 18px' }}>
        <Button variant="secondary" fullWidth onClick={onCancel}>{cancel}</Button>
        <Button variant="primary" fullWidth onClick={onConfirm} style={destructive ? { background: 'var(--error)' } : undefined}>{confirm}</Button>
      </div>
    </div>
  );
}

/* G3 · Dialog (destructive confirm) */
function DialogScreen() {
  const nav = useNav();
  return (
    <Frame bg="var(--surface)">
      <div style={{ flex: 1, overflow: 'hidden', position: 'relative' }}>
        <DimBackdrop />
        <div onClick={nav.back} style={{ position: 'absolute', inset: 0, background: 'var(--overlay)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <div onClick={(e) => e.stopPropagation()}>
            <Dialog title="Delete post?" body="This can't be undone. Your photo and all its likes and comments will be removed." confirm="Delete" destructive onCancel={nav.back} onConfirm={() => { nav.toast('Post deleted'); nav.back(); }} />
          </div>
        </div>
      </div>
    </Frame>
  );
}

/* ---------- ACTION SHEET ---------- */
function ActionSheet({ items }) {
  const { Icon } = W36;
  return (
    <div style={{ background: 'var(--surface)', borderTopLeftRadius: 24, borderTopRightRadius: 24, overflow: 'hidden', boxShadow: '0 -8px 40px rgba(26,26,46,.25)', paddingBottom: 8 }}>
      <div style={{ width: 38, height: 4, borderRadius: 2, background: 'var(--border-strong)', margin: '10px auto 6px' }} />
      {items.map((it, i) => (
        <div key={i} onClick={it.onClick} style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 14, padding: '15px 22px', borderTop: i ? '1px solid var(--divider)' : 'none', color: it.danger ? 'var(--error)' : 'var(--text-primary)' }}>
          <Icon name={it.icon} size={22} color={it.danger ? 'var(--error)' : 'var(--icon)'} />
          <span style={{ fontSize: 16, fontWeight: 500 }}>{it.label}</span>
        </div>
      ))}
    </div>
  );
}

/* G4 · Action sheet (post options) */
function ActionSheetScreen() {
  const nav = useNav();
  return (
    <Frame bg="var(--surface)">
      <div style={{ flex: 1, overflow: 'hidden', position: 'relative', display: 'flex', flexDirection: 'column' }}>
        <DimBackdrop />
        <div onClick={nav.back} style={{ position: 'absolute', inset: 0, background: 'var(--overlay)', display: 'flex', flexDirection: 'column', justifyContent: 'flex-end' }}>
          <div onClick={(e) => e.stopPropagation()}>
          <ActionSheet items={[
            { icon: 'save', label: 'Save to collection', onClick: () => { nav.toast('Saved to collection'); nav.back(); } },
            { icon: 'share', label: 'Share to…', onClick: () => { nav.toast('Shared'); nav.back(); } },
            { icon: 'plus', label: 'Add to story', onClick: () => { nav.toast('Added to your story'); nav.back(); } },
            { icon: 'notification', label: 'Turn on notifications', onClick: () => { nav.toast('Notifications on'); nav.back(); } },
            { icon: 'x', label: 'Report', danger: true, onClick: () => nav.go('report') },
          ]} />
          <div style={{ padding: '8px 14px 18px' }}>
            <div onClick={nav.back} style={{ cursor: 'pointer', height: 50, borderRadius: 16, background: 'var(--surface)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: 700, fontSize: 16, boxShadow: '0 2px 10px rgba(26,26,46,.1)' }}>Cancel</div>
          </div>
          </div>
        </div>
      </div>
    </Frame>
  );
}

Object.assign(window, { StickerGlyph, StickerTray, StickerPickerScreen, Toast, ToastScreen, ToastVariantsScreen, Dialog, DialogScreen, ActionSheet, ActionSheetScreen });

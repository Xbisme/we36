/* We36 — tablet / iPad layouts. Sidebar rail + multi-column + split views.
   Reuses DS components and the same NavCtx nav model as mobile. */

const TABLET_POSTS = [
  { user: 'maya.travels', avatar: IMG.maya, location: 'Lisbon, Portugal', image: PHOTO('photo-1513735492246-483525079686', 900, 1100), likes: 1240, caption: 'golden hour never misses ☀️ #goldenhour', comments: 86, time: '2h' },
  { user: 'devon.shoots', avatar: IMG.devon, location: 'Tokyo, Japan', image: PHOTO('photo-1542051841857-5f90071e7989', 900, 1100), likes: 873, caption: 'neon nights in Shibuya 🌃 #tokyo', comments: 41, time: '5h' },
];
const TAB_STORIES = [
  { user: 'Your story', me: true, img: IMG.kai },
  { user: 'maya', img: IMG.maya }, { user: 'devon', img: IMG.devon },
  { user: 'aisha', seen: true, img: IMG.aisha }, { user: 'liam', img: IMG.liam },
  { user: 'noor', img: IMG.noor }, { user: 'sofia', seen: true, img: IMG.sofia },
];
const SUGGESTIONS = [
  { img: IMG.noor, name: 'noor.films', sub: 'Followed by liam' },
  { img: IMG.sofia, name: 'sofia.eats', sub: 'New to We36' },
  { img: IMG.kai, name: 'kai', sub: 'Suggested for you' },
  { img: IMG.aisha, name: 'aisha.k', sub: 'Follows you' },
];
const DM_CHATS = [
  { img: IMG.devon, name: 'devon.shoots', msg: 'sent the raw files 📁', time: '2m', unread: true, online: true },
  { img: IMG.aisha, name: 'aisha.k', msg: 'haha that reel 😂', time: '18m', unread: true },
  { img: IMG.maya, name: 'maya.travels', msg: 'You: see you in lisbon!', time: '1h' },
  { img: IMG.noor, name: 'noor.films', msg: 'shared a post', time: '3h', online: true },
  { img: IMG.liam, name: 'liam', msg: 'thanks for the follow 🙌', time: '1d' },
  { img: IMG.sofia, name: 'sofia.eats', msg: 'Typing…', time: '2d', typing: true },
];

/* which sidebar item is active for a given screen */
function activeNavFor(s) {
  if (['home', 'postdetail', 'comments'].includes(s)) return 'home';
  if (['explore', 'search', 'results', 'hashtag'].includes(s)) return 'search';
  if (s === 'reels') return 'reels';
  if (['dmlist', 'chat', 'newmessage', 'stickers'].includes(s)) return 'message';
  if (s === 'notifications') return 'notification';
  if (s.startsWith('create')) return 'plus';
  return 'profile';
}

/* ---------- left sidebar rail ---------- */
function SidebarRail({ current, compact }) {
  const { Icon, Avatar } = W36;
  const nav = useNav();
  const active = activeNavFor(current);
  const items = [
    { key: 'home', icon: 'home', label: 'Home', go: () => nav.tab('home') },
    { key: 'search', icon: 'search', label: 'Explore', go: () => nav.tab('search') },
    { key: 'reels', icon: 'reels', label: 'Reels', go: () => nav.tab('reels') },
    { key: 'message', icon: 'message', label: 'Messages', go: () => nav.tab('message'), badge: 3 },
    { key: 'notification', icon: 'notification', label: 'Notifications', go: () => nav.go('notifications') },
    { key: 'plus', icon: 'plus', label: 'Create', go: () => nav.go('createpick') },
  ];
  return (
    <nav style={{ width: compact ? 84 : 240, flexShrink: 0, height: '100%', background: 'var(--surface)', borderRight: '1px solid var(--divider)', display: 'flex', flexDirection: 'column', padding: compact ? '20px 12px' : '22px 16px', gap: 4 }}>
      <div style={{ padding: compact ? '0 0 18px' : '0 10px 22px', display: 'flex', justifyContent: compact ? 'center' : 'flex-start' }}>
        {compact ? <Wordmark size={22} /> : <Wordmark size={28} />}
      </div>
      {items.map((it) => {
        const on = it.key === active;
        return (
          <div key={it.key} onClick={it.go} title={it.label}
            style={{ display: 'flex', alignItems: 'center', gap: 16, padding: compact ? '12px' : '12px 14px', borderRadius: 999, cursor: 'pointer', justifyContent: compact ? 'center' : 'flex-start',
              background: on ? 'var(--accent-soft)' : 'transparent', color: on ? 'var(--rose-500)' : 'var(--text-primary)', fontWeight: on ? 700 : 500 }}>
            <span style={{ position: 'relative', display: 'flex' }}>
              <Icon name={it.icon} size={26} color={on ? 'var(--rose-500)' : 'var(--icon)'} solid={on} />
              {it.badge && <span style={{ position: 'absolute', top: -4, right: -6, minWidth: 16, height: 16, padding: '0 4px', borderRadius: 999, background: 'var(--rose-500)', color: '#fff', fontSize: 10, fontWeight: 700, display: 'flex', alignItems: 'center', justifyContent: 'center', border: '2px solid var(--surface)' }}>{it.badge}</span>}
            </span>
            {!compact && <span style={{ fontSize: 16 }}>{it.label}</span>}
          </div>
        );
      })}
      <div style={{ flex: 1 }} />
      <div onClick={() => nav.tab('profile')} style={{ display: 'flex', alignItems: 'center', gap: 12, padding: compact ? '10px' : '10px 12px', borderRadius: 999, cursor: 'pointer', justifyContent: compact ? 'center' : 'flex-start', background: active === 'profile' ? 'var(--accent-soft)' : 'transparent' }}>
        <Avatar src={IMG.maya} size={compact ? 36 : 34} ring={active === 'profile'} />
        {!compact && <div style={{ minWidth: 0 }}><div style={{ fontSize: 14, fontWeight: 700, overflow: 'hidden', textOverflow: 'ellipsis' }}>maya.travels</div><div style={{ fontSize: 12, color: 'var(--text-secondary)' }}>Maya Oliveira</div></div>}
      </div>
    </nav>
  );
}

/* ---------- content header (per-screen title bar) ---------- */
function PaneHeader({ title, back, action }) {
  const { Icon } = W36;
  const nav = useNav();
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 10, height: 60, padding: '0 24px', borderBottom: '1px solid var(--divider)', background: 'var(--surface)', flexShrink: 0 }}>
      {back && <span onClick={nav.back} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="chevronLeft" size={24} color="var(--text-primary)" /></span>}
      <span style={{ fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 22 }}>{title}</span>
      <div style={{ marginLeft: 'auto' }}>{action}</div>
    </div>
  );
}

/* ---------- TABLET · Home feed ---------- */
function TabletFeed({ rightRail }) {
  const { PostCard, Avatar, Icon, SearchBar, Button } = W36;
  const nav = useNav();
  return (
    <div style={{ flex: 1, display: 'flex', minWidth: 0, background: 'var(--bg-app)' }}>
      <div className="frame-scroll" style={{ flex: 1, overflowY: 'auto', display: 'flex', justifyContent: 'center', padding: '24px 24px 60px' }}>
        <div style={{ width: '100%', maxWidth: 560 }}>
          {/* stories rail */}
          <div className="frame-scroll" style={{ display: 'flex', gap: 18, padding: '14px 16px', background: 'var(--surface)', border: '1px solid var(--border)', borderRadius: 20, overflowX: 'auto', marginBottom: 22 }}>
            {TAB_STORIES.map((s, i) => (
              <div key={i} onClick={() => nav.go(s.me ? 'createstory' : 'story')} style={{ cursor: 'pointer', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6, flexShrink: 0, width: 68 }}>
                <div style={{ position: 'relative' }}>
                  <Avatar src={s.img} size={60} ring={!s.me} seen={s.seen} />
                  {s.me && <span style={{ position: 'absolute', right: -2, bottom: -2, width: 22, height: 22, borderRadius: '50%', background: 'var(--gradient-brand)', display: 'flex', alignItems: 'center', justifyContent: 'center', border: '2px solid var(--surface)' }}><Icon name="plus" size={13} color="#fff" /></span>}
                </div>
                <span style={{ fontSize: 12, color: 'var(--text-secondary)', maxWidth: 68, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{s.user}</span>
              </div>
            ))}
          </div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 24 }}>
            {TABLET_POSTS.map((p, i) => (
              <div key={i} onClick={() => nav.go('postdetail')} style={{ cursor: 'pointer' }}><PostCard {...p} style={{ maxWidth: '100%' }} /></div>
            ))}
          </div>
        </div>
      </div>
      {rightRail && (
        <aside className="frame-scroll" style={{ width: 340, flexShrink: 0, borderLeft: '1px solid var(--divider)', background: 'var(--surface)', overflowY: 'auto', padding: '24px 24px 40px' }}>
          <div onClick={() => nav.go('search')} style={{ cursor: 'pointer', marginBottom: 22 }}><SearchBar placeholder="Search" /></div>
          <div onClick={() => nav.tab('profile')} style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 12, marginBottom: 24 }}>
            <Avatar src={IMG.maya} size={56} ring />
            <div style={{ flex: 1 }}><div style={{ fontWeight: 700, fontSize: 15 }}>maya.travels</div><div style={{ fontSize: 13, color: 'var(--text-secondary)' }}>Maya Oliveira</div></div>
            <span style={{ color: 'var(--rose-500)', fontWeight: 700, fontSize: 13 }}>Switch</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', marginBottom: 12 }}>
            <span style={{ fontSize: 14, fontWeight: 700, color: 'var(--text-secondary)' }}>Suggestions for you</span>
            <span style={{ marginLeft: 'auto', fontSize: 12, fontWeight: 700 }}>See all</span>
          </div>
          {SUGGESTIONS.map((s, i) => (
            <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '8px 0' }}>
              <Avatar src={s.img} size={44} />
              <div style={{ flex: 1, minWidth: 0 }}><div style={{ fontSize: 14, fontWeight: 600 }}>{s.name}</div><div style={{ fontSize: 12, color: 'var(--text-tertiary)' }}>{s.sub}</div></div>
              <span onClick={() => nav.toast('Following ' + s.name)} style={{ cursor: 'pointer', color: 'var(--rose-500)', fontWeight: 700, fontSize: 13 }}>Follow</span>
            </div>
          ))}
          <div style={{ marginTop: 24, fontSize: 12, color: 'var(--text-tertiary)', lineHeight: '20px' }}>About · Help · Press · API · Jobs · Privacy · Terms<br />© 2026 We36</div>
        </aside>
      )}
    </div>
  );
}

/* ---------- TABLET · Explore ---------- */
function TabletExplore() {
  const { SearchBar, Tag, Icon } = W36;
  const nav = useNav();
  const tags = [['For you', true], ['travel'], ['food'], ['design'], ['fitness'], ['art'], ['nature']];
  const grid = GRID_IDS.concat(GRID_IDS);
  return (
    <div style={{ flex: 1, display: 'flex', flexDirection: 'column', minWidth: 0, background: 'var(--bg-app)' }}>
      <div style={{ padding: '20px 28px 14px', background: 'var(--surface)', borderBottom: '1px solid var(--divider)', flexShrink: 0 }}>
        <div style={{ maxWidth: 520 }} onClick={() => nav.go('search')}><SearchBar placeholder="Search people, tags, places" /></div>
        <div className="frame-scroll" style={{ display: 'flex', gap: 8, marginTop: 14, overflowX: 'auto' }}>
          {tags.map(([l, a], i) => <Tag key={i} active={a} hashtag={i > 0} onClick={i > 0 ? () => nav.go('hashtag') : undefined} style={{ flexShrink: 0 }}>{l}</Tag>)}
        </div>
      </div>
      <div className="frame-scroll" style={{ flex: 1, overflowY: 'auto', padding: 24 }}>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(200px, 1fr))', gap: 8 }}>
          {grid.map((id, i) => (
            <div key={i} onClick={() => nav.go('postdetail')} style={{ cursor: 'pointer', aspectRatio: '1', overflow: 'hidden', borderRadius: 12, position: 'relative', background: 'var(--surface-2)' }}>
              <img src={PHOTO(id, 400, 400)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
              {i % 5 === 2 && <span style={{ position: 'absolute', top: 8, right: 8 }}><Icon name="reels" size={20} color="#fff" solid /></span>}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

/* ---------- TABLET · Messages (split) ---------- */
function TabletMessages() {
  const { Avatar, Icon, SearchBar } = W36;
  const nav = useNav();
  const [sel, setSel] = React.useState(0);
  const c = DM_CHATS[sel];
  const Bubble = ({ me, children, tail }) => (
    <div style={{ alignSelf: me ? 'flex-end' : 'flex-start', maxWidth: '70%', background: me ? 'var(--gradient-brand)' : 'var(--surface-2)', color: me ? '#fff' : 'var(--text-primary)', padding: '10px 15px', borderRadius: 20, borderBottomRightRadius: me && tail ? 6 : 20, borderBottomLeftRadius: !me && tail ? 6 : 20, fontSize: 15, lineHeight: '21px' }}>{children}</div>
  );
  return (
    <div style={{ flex: 1, display: 'flex', minWidth: 0, background: 'var(--surface)' }}>
      {/* conversation list */}
      <div style={{ width: 360, flexShrink: 0, borderRight: '1px solid var(--divider)', display: 'flex', flexDirection: 'column' }}>
        <div style={{ display: 'flex', alignItems: 'center', height: 60, padding: '0 20px', flexShrink: 0 }}>
          <span style={{ fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 20 }}>Messages</span>
          <span onClick={() => nav.go('newmessage')} style={{ cursor: 'pointer', marginLeft: 'auto', display: 'flex' }}><Icon name="plus" size={24} color="var(--icon)" /></span>
        </div>
        <div style={{ padding: '0 16px 12px', flexShrink: 0 }}><SearchBar placeholder="Search messages" /></div>
        <div className="frame-scroll" style={{ flex: 1, overflowY: 'auto' }}>
          {DM_CHATS.map((ch, i) => (
            <div key={i} onClick={() => setSel(i)} style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 12, padding: '10px 16px', background: i === sel ? 'var(--accent-soft)' : 'transparent' }}>
              <Avatar src={ch.img} size={50} online={ch.online} />
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 15, fontWeight: ch.unread ? 700 : 600 }}>{ch.name}</div>
                <div style={{ fontSize: 13, color: ch.typing ? 'var(--mint-500)' : ch.unread ? 'var(--text-primary)' : 'var(--text-secondary)', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{ch.msg} · {ch.time}</div>
              </div>
              {ch.unread && <span style={{ width: 9, height: 9, borderRadius: '50%', background: 'var(--rose-500)' }} />}
            </div>
          ))}
        </div>
      </div>
      {/* chat pane */}
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', minWidth: 0 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, height: 60, padding: '0 20px', borderBottom: '1px solid var(--divider)', flexShrink: 0 }}>
          <Avatar src={c.img} size={40} online={c.online} />
          <div><div style={{ fontSize: 15, fontWeight: 700 }}>{c.name}</div><div style={{ fontSize: 12, color: c.online ? 'var(--mint-500)' : 'var(--text-tertiary)' }}>{c.online ? 'Active now' : 'Active ' + c.time + ' ago'}</div></div>
          <div style={{ marginLeft: 'auto', display: 'flex', gap: 16 }}><Icon name="camera" size={22} color="var(--icon)" /><Icon name="more" size={22} color="var(--icon)" /></div>
        </div>
        <div className="frame-scroll" style={{ flex: 1, overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: 8, padding: '20px 24px', justifyContent: 'flex-end' }}>
          <div style={{ textAlign: 'center', fontSize: 12, color: 'var(--text-tertiary)', marginBottom: 6 }}>Today 9:24</div>
          <Bubble>hey! did the tokyo shots come out?</Bubble>
          <Bubble me>yeah they're unreal 🔥</Bubble>
          <Bubble me tail>sending the raw files now</Bubble>
          <div style={{ alignSelf: 'flex-end', maxWidth: 280, borderRadius: 16, overflow: 'hidden', border: '1px solid var(--border)' }}>
            <img src={PHOTO('photo-1542051841857-5f90071e7989', 500, 320)} alt="" style={{ width: '100%', height: 150, objectFit: 'cover', display: 'block' }} />
            <div style={{ padding: '8px 12px', fontSize: 13 }}><span style={{ fontWeight: 700 }}>{c.name}</span> · neon nights 🌃</div>
          </div>
          <Bubble tail>saved 🙌 posting tomorrow</Bubble>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '14px 20px', borderTop: '1px solid var(--divider)', flexShrink: 0 }}>
          <span style={{ width: 40, height: 40, borderRadius: '50%', background: 'var(--gradient-brand)', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}><Icon name="camera" size={20} color="#fff" /></span>
          <div onClick={() => nav.go('stickers')} style={{ cursor: 'pointer', flex: 1, height: 44, borderRadius: 999, background: 'var(--surface-2)', display: 'flex', alignItems: 'center', padding: '0 16px', gap: 8 }}>
            <span style={{ flex: 1, color: 'var(--text-tertiary)', fontSize: 15 }}>Message…</span>
            <StickerGlyph size={22} color="var(--icon)" />
          </div>
          <Icon name="like" size={24} color="var(--icon)" />
        </div>
      </div>
    </div>
  );
}

/* ---------- TABLET · Profile ---------- */
function TabletProfile({ current }) {
  const { Avatar, Button, Icon } = W36;
  const nav = useNav();
  const me = current !== 'otherprofile';
  const d = me
    ? { name: 'Maya Oliveira', user: 'maya.travels', img: IMG.maya, bio: 'Chasing light around the world 🌍 Lisbon-based · prints in bio', link: 'we36.app/maya', stats: ['248', '38.4k', '612'], slice: [0, 12] }
    : { name: 'Devon Park', user: 'devon.shoots', img: IMG.devon, bio: 'night & street 📷 tokyo → everywhere. dm for prints', link: 'we36.app/devon', stats: ['512', '91.2k', '340'], slice: [3, 12] };
  const Stat = ({ n, l, onClick }) => (
    <div onClick={onClick} style={{ cursor: onClick ? 'pointer' : 'default', textAlign: 'center' }}>
      <span style={{ fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 20 }}>{n}</span>
      <span style={{ fontSize: 14, color: 'var(--text-secondary)', marginLeft: 6 }}>{l}</span>
    </div>
  );
  return (
    <div style={{ flex: 1, display: 'flex', flexDirection: 'column', minWidth: 0, background: 'var(--bg-app)' }}>
      <PaneHeader title={d.user} back={!me} action={me ? <span onClick={() => nav.go('settings')} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="settings" size={22} color="var(--icon)" /></span> : <span onClick={() => nav.go('actionsheet')} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="more" size={22} color="var(--icon)" /></span>} />
      <div className="frame-scroll" style={{ flex: 1, overflowY: 'auto', padding: '32px 40px 60px' }}>
        <div style={{ maxWidth: 900, margin: '0 auto' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 48, marginBottom: 28 }}>
            <Avatar src={d.img} size={130} ring />
            <div style={{ flex: 1 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 16, marginBottom: 16 }}>
                <span style={{ fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 24 }}>{d.user}</span>
                {me
                  ? <React.Fragment><Button variant="secondary" onClick={() => nav.go('editprofile')}>Edit profile</Button><Button variant="secondary" onClick={() => nav.toast('Profile link copied')}>Share profile</Button></React.Fragment>
                  : <React.Fragment><Button variant="primary" onClick={() => nav.toast('Following ' + d.user)}>Follow</Button><Button variant="secondary" onClick={() => nav.go('chat')}>Message</Button></React.Fragment>}
              </div>
              <div style={{ display: 'flex', gap: 40, marginBottom: 14 }}>
                <Stat n={d.stats[0]} l="posts" />
                <Stat n={d.stats[1]} l="followers" onClick={() => nav.go('followers')} />
                <Stat n={d.stats[2]} l="following" onClick={() => nav.go('followers')} />
              </div>
              <div style={{ fontWeight: 700, fontSize: 15 }}>{d.name}</div>
              <div style={{ fontSize: 15, lineHeight: '22px', marginTop: 2 }}>{d.bio}</div>
              <div style={{ fontSize: 15, color: 'var(--violet-500)', fontWeight: 600, marginTop: 2 }}>{d.link}</div>
            </div>
          </div>
          <div style={{ display: 'flex', justifyContent: 'center', gap: 48, borderTop: '1px solid var(--border)', marginBottom: 4 }}>
            {[['home', 'Posts', 0], ['save', 'Saved', 1], ['profile', 'Tagged', 2]].map(([ic, lbl, i]) => (
              <div key={lbl} onClick={() => { if (me && i === 1) nav.go('collections'); }} style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 8, padding: '16px 0', borderTop: i === 0 ? '2px solid var(--text-primary)' : '2px solid transparent', marginTop: -1, color: i === 0 ? 'var(--text-primary)' : 'var(--text-secondary)', fontWeight: 600, fontSize: 13, letterSpacing: '.03em', textTransform: 'uppercase' }}>
                <Icon name={ic} size={18} color={i === 0 ? 'var(--text-primary)' : 'var(--icon)'} solid={i === 0} />{lbl}
              </div>
            ))}
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(180px, 1fr))', gap: 6 }}>
            {GRID_IDS.slice(d.slice[0], d.slice[1]).map((id, i) => (
              <div key={i} onClick={() => nav.go('postdetail')} style={{ cursor: 'pointer', aspectRatio: '1', overflow: 'hidden', borderRadius: 8, background: 'var(--surface-2)' }}>
                <img src={PHOTO(id, 360, 360)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

/* ---------- TABLET · Reels ---------- */
function TabletReels() {
  const { Avatar, Icon, Button } = W36;
  const nav = useNav();
  const Action = ({ name, count, active, onClick }) => (
    <div onClick={onClick} style={{ cursor: 'pointer', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, color: '#fff' }}>
      <Icon name={name} size={32} color={active ? 'var(--rose-500)' : '#fff'} solid={active} />
      {count != null && <span style={{ fontSize: 13, fontWeight: 600 }}>{count}</span>}
    </div>
  );
  return (
    <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', minWidth: 0, background: '#0E0E1A', padding: 24 }}>
      <div style={{ position: 'relative', height: '100%', maxHeight: 720, aspectRatio: '9 / 16', borderRadius: 24, overflow: 'hidden', background: '#000', boxShadow: '0 30px 70px rgba(0,0,0,.5)' }}>
        <img src={PHOTO('photo-1518609878373-06d740f60d8b', 800, 1500)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover', opacity: .92 }} />
        <div style={{ position: 'absolute', top: 18, left: 18, right: 18, display: 'flex', alignItems: 'center' }}>
          <span style={{ fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 18, color: '#fff' }}>Reels</span>
          <span onClick={() => nav.go('createstory')} style={{ cursor: 'pointer', marginLeft: 'auto', display: 'flex' }}><Icon name="camera" size={24} color="#fff" /></span>
        </div>
        <div style={{ position: 'absolute', right: 16, bottom: 36, display: 'flex', flexDirection: 'column', gap: 22, alignItems: 'center' }}>
          <Action name="like" count="24.1k" active />
          <Action name="comment" count="318" onClick={() => nav.go('comments')} />
          <Action name="share" count="1.2k" onClick={() => nav.go('actionsheet')} />
          <Action name="save" />
          <span onClick={() => nav.go('actionsheet')} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="more" size={26} color="#fff" /></span>
        </div>
        <div style={{ position: 'absolute', left: 18, right: 88, bottom: 28, color: '#fff' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 10 }}>
            <Avatar src={IMG.devon} size={38} />
            <span style={{ fontWeight: 700, fontSize: 15 }}>devon.shoots</span>
            <Button variant="secondary" size="sm" style={{ height: 30, background: 'transparent', color: '#fff', borderColor: 'rgba(255,255,255,.7)' }} onClick={() => nav.toast('Following devon.shoots')}>Follow</Button>
          </div>
          <div style={{ fontSize: 15, lineHeight: '21px', textShadow: '0 1px 8px rgba(0,0,0,.5)' }}>cinematic walk through the old town 🎬 <span style={{ fontWeight: 600 }}>#reels #travel</span></div>
        </div>
        <div style={{ position: 'absolute', left: 0, right: 0, bottom: 0, height: 160, background: 'linear-gradient(to top, rgba(0,0,0,.55), transparent)', pointerEvents: 'none' }} />
      </div>
    </div>
  );
}

/* ---------- TABLET · Post detail (split: media + comments) ---------- */
function TabletPostDetail() {
  const { Avatar, Icon, Button } = W36;
  const nav = useNav();
  const C = ({ img, user, text, time, likes, reply }) => (
    <div style={{ display: 'flex', gap: 12, padding: reply ? '8px 0 8px 44px' : '12px 0' }}>
      <Avatar src={img} size={reply ? 30 : 36} />
      <div style={{ flex: 1 }}>
        <div style={{ fontSize: 14, lineHeight: '20px' }}><span style={{ fontWeight: 700 }}>{user}</span> {text}</div>
        <div style={{ display: 'flex', gap: 16, marginTop: 5, fontSize: 12, color: 'var(--text-tertiary)', fontWeight: 600 }}><span>{time}</span><span>{likes} likes</span><span>Reply</span></div>
      </div>
      <Icon name="like" size={15} color="var(--icon)" style={{ marginTop: 4 }} />
    </div>
  );
  return (
    <div style={{ flex: 1, display: 'flex', flexDirection: 'column', minWidth: 0, background: 'var(--bg-app)' }}>
      <PaneHeader title="Post" back />
      <div style={{ flex: 1, display: 'flex', minHeight: 0 }}>
        {/* media */}
        <div style={{ flex: 1, minWidth: 0, background: '#0E0E1A', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 24 }}>
          <img src={PHOTO('photo-1542051841857-5f90071e7989', 1000, 1000)} alt="" style={{ maxWidth: '100%', maxHeight: '100%', objectFit: 'contain', borderRadius: 12 }} />
        </div>
        {/* info + comments */}
        <div style={{ width: 400, flexShrink: 0, borderLeft: '1px solid var(--divider)', background: 'var(--surface)', display: 'flex', flexDirection: 'column' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '16px 20px', borderBottom: '1px solid var(--divider)', flexShrink: 0 }}>
            <Avatar src={IMG.devon} size={40} ring />
            <div style={{ flex: 1 }}><div style={{ fontWeight: 700, fontSize: 14 }} onClick={() => nav.go('otherprofile')}>devon.shoots</div><div style={{ fontSize: 12, color: 'var(--text-secondary)' }}>Tokyo, Japan</div></div>
            <Button variant="primary" size="sm" onClick={() => nav.toast('Following devon.shoots')}>Follow</Button>
          </div>
          <div className="frame-scroll" style={{ flex: 1, overflowY: 'auto', padding: '4px 20px' }}>
            <div style={{ display: 'flex', gap: 12, padding: '12px 0' }}>
              <Avatar src={IMG.devon} size={36} />
              <div style={{ fontSize: 14, lineHeight: '20px' }}><span style={{ fontWeight: 700 }}>devon.shoots</span> neon nights in Shibuya 🌃 <span style={{ color: 'var(--violet-500)' }}>#tokyo #nightphotography</span></div>
            </div>
            <C img={IMG.aisha} user="aisha.k" text="this is unreal 😍 what lens?" time="2h" likes={12} />
            <C img={IMG.devon} user="devon.shoots" text="35mm, golden hour magic ✨" time="1h" likes={4} reply />
            <C img={IMG.liam} user="liam" text="saving this for inspo 🔥" time="3h" likes={8} />
            <C img={IMG.noor} user="noor.films" text="the colors here are perfect" time="4h" likes={21} />
            <C img={IMG.sofia} user="sofia" text="okay this is my new wallpaper" time="5h" likes={2} />
          </div>
          <div style={{ padding: '12px 20px', borderTop: '1px solid var(--divider)', flexShrink: 0 }}>
            <div style={{ display: 'flex', gap: 18, marginBottom: 10 }}>
              <Icon name="like" size={26} color="var(--icon)" />
              <Icon name="comment" size={26} color="var(--icon)" />
              <Icon name="share" size={26} color="var(--icon)" />
              <Icon name="save" size={26} color="var(--icon)" style={{ marginLeft: 'auto' }} />
            </div>
            <div style={{ fontWeight: 700, fontSize: 14 }}>873 likes</div>
            <div style={{ fontSize: 12, color: 'var(--text-tertiary)', marginTop: 2 }}>5 hours ago</div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginTop: 12 }}>
              <div onClick={() => nav.go('stickers')} style={{ cursor: 'pointer', flex: 1, height: 40, borderRadius: 999, background: 'var(--surface-2)', display: 'flex', alignItems: 'center', padding: '0 14px', gap: 8 }}>
                <span style={{ flex: 1, color: 'var(--text-tertiary)', fontSize: 14 }}>Add a comment…</span>
                <StickerGlyph size={20} color="var(--icon)" />
              </div>
              <span style={{ color: 'var(--rose-500)', fontWeight: 700, fontSize: 14 }}>Post</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

/* ---------- TABLET · Notifications (centered list) ---------- */
function TabletNotifications() {
  const { Avatar, Button, Icon } = W36;
  const nav = useNav();
  const Item = ({ img, children, thumb, time, follow }) => (
    <div onClick={() => nav.go(follow ? 'otherprofile' : 'postdetail')} style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 14, padding: '12px 0' }}>
      <Avatar src={img} size={48} />
      <div style={{ flex: 1, fontSize: 15, lineHeight: '20px' }}>{children} <span style={{ color: 'var(--text-tertiary)' }}>{time}</span></div>
      {follow ? <Button variant={follow === 'following' ? 'secondary' : 'primary'} size="sm" style={{ minWidth: 96 }}>{follow === 'following' ? 'Following' : 'Follow'}</Button>
        : thumb && <div style={{ width: 48, height: 48, borderRadius: 8, overflow: 'hidden' }}><img src={PHOTO(thumb, 100, 100)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} /></div>}
    </div>
  );
  return (
    <div style={{ flex: 1, display: 'flex', flexDirection: 'column', minWidth: 0, background: 'var(--surface)' }}>
      <PaneHeader title="Notifications" />
      <div className="frame-scroll" style={{ flex: 1, overflowY: 'auto', padding: '12px 40px 40px' }}>
        <div style={{ maxWidth: 620, margin: '0 auto' }}>
          <div style={{ padding: '14px 0 6px', fontWeight: 700, fontSize: 15 }}>New</div>
          <Item img={IMG.devon} time="2m" thumb="photo-1513735492246-483525079686"><b>devon.shoots</b> liked your photo</Item>
          <Item img={IMG.aisha} time="18m" follow="follow"><b>aisha.k</b> started following you</Item>
          <Item img={IMG.noor} time="1h" thumb="photo-1542051841857-5f90071e7989"><b>noor.films</b> commented: "the colors 😍"</Item>
          <div style={{ padding: '14px 0 6px', fontWeight: 700, fontSize: 15 }}>This week</div>
          <Item img={IMG.liam} time="2d" follow="following"><b>liam</b> and <b>3 others</b> followed you</Item>
          <Item img={IMG.sofia} time="3d" thumb="photo-1493246507139-91e8fad9978e"><b>sofia.eats</b> mentioned you in a comment</Item>
          <Item img={IMG.kai} time="5d" thumb="photo-1500534314209-a25ddb2bd429"><b>kai</b> saved your post</Item>
        </div>
      </div>
    </div>
  );
}

/* ---------- centered mobile screen (fallback for secondary screens) ---------- */
function CenteredMobile({ screenKey }) {
  const Screen = window[SCREEN_FNS[screenKey]] || window.HomeFeedScreen;
  const dark = ['story', 'createstory', 'actionsheet', 'dialog'].includes(screenKey);
  return (
    <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', minWidth: 0, background: 'var(--bg-app)', padding: 24 }}>
      <div style={{ width: 390, height: 760, borderRadius: 28, overflow: 'hidden', boxShadow: '0 24px 60px rgba(26,26,46,.24)', flexShrink: 0 }}><Screen /></div>
    </div>
  );
}

/* map screen key -> mobile function name (for CenteredMobile) */
const SCREEN_FNS = {
  story: 'StoryViewerScreen', createstory: 'CreateStoryScreen', createpick: 'CreatePickScreen', createedit: 'CreateEditScreen', createcaption: 'CreateCaptionScreen',
  search: 'SearchScreen', results: 'SearchResultsScreen', hashtag: 'HashtagScreen',
  followers: 'FollowersScreen', editprofile: 'EditProfileScreen', collections: 'CollectionsScreen',
  newmessage: 'NewMessageScreen', stickers: 'StickerPickerScreen',
  settings: 'SettingsScreen', privacy: 'PrivacyScreen', report: 'ReportScreen',
  actionsheet: 'ActionSheetScreen', dialog: 'DialogScreen', comments: 'CommentsScreen',
};

/* ---------- the tablet app shell ---------- */
const TABLET_BESPOKE = {
  home: TabletFeed, explore: TabletExplore, reels: TabletReels,
  dmlist: TabletMessages, chat: TabletMessages,
  myprofile: TabletProfile, otherprofile: TabletProfile,
  postdetail: TabletPostDetail, notifications: TabletNotifications,
};

function TabletApp({ width, rightRail, current }) {
  const compact = width < 980; // portrait → icon-only rail

  const Bespoke = TABLET_BESPOKE[current];
  let content;
  if (current === 'home') content = <TabletFeed rightRail={rightRail} />;
  else if (current === 'myprofile' || current === 'otherprofile') content = <TabletProfile current={current} />;
  else if (Bespoke) content = <Bespoke />;
  else content = <CenteredMobile screenKey={current} />;

  return (
    <div style={{ display: 'flex', height: '100%', width: '100%', background: 'var(--bg-app)', fontFamily: 'var(--font-body)', color: 'var(--text-primary)' }}>
      <SidebarRail current={current} compact={compact} />
      {content}
    </div>
  );
}

Object.assign(window, { TabletApp, SidebarRail, activeNavFor });

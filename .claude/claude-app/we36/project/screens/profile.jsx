/* We36 — D. Profile screens */

function Stat({ n, label }) {
  return (
    <div style={{ textAlign: 'center' }}>
      <div style={{ fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 18, color: 'var(--text-primary)' }}>{n}</div>
      <div style={{ fontSize: 12, color: 'var(--text-secondary)' }}>{label}</div>
    </div>
  );
}

function ProfileTabs({ active, onTab }) {
  const { Icon } = W36;
  return (
    <div style={{ display: 'flex', borderBottom: '1px solid var(--divider)', background: 'var(--surface)', flexShrink: 0 }}>
      {['home','save','profile'].map((ic, i) => (
        <div key={i} onClick={onTab ? () => onTab(i) : undefined} style={{ cursor: onTab ? 'pointer' : 'default', flex: 1, display: 'flex', justifyContent: 'center', padding: '10px 0', borderBottom: i === active ? '2px solid var(--text-primary)' : '2px solid transparent', marginBottom: -1 }}>
          <Icon name={['home','save','profile'][i]} size={22} color={i === active ? 'var(--text-primary)' : 'var(--icon)'} solid={i === active} />
        </div>
      ))}
    </div>
  );
}

/* D1 · My profile */
function MyProfileScreen() {
  const { Avatar, Button, Icon, BottomNav } = W36;
  const nav = useNav();
  return (
    <Frame bg="var(--bg-app)" nav={<BottomNav active="profile" onChange={nav.tab} badges={{ message: 3 }} />}>
      <header style={{ display: 'flex', alignItems: 'center', padding: '0 16px', height: 52, background: 'var(--surface)', flexShrink: 0 }}>
        <span style={{ fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 18 }}>maya.travels</span>
        <div style={{ marginLeft: 'auto', display: 'flex', gap: 14 }}><span onClick={() => nav.go('createpick')} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="plus" size={24} color="var(--icon)" /></span><span onClick={() => nav.go('settings')} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="settings" size={22} color="var(--icon)" /></span></div>
      </header>
      <div style={{ padding: '14px 16px', background: 'var(--surface)', flexShrink: 0 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 22 }}>
          <Avatar src={IMG.maya} size={88} ring />
          <div style={{ display: 'flex', flex: 1, justifyContent: 'space-around' }}><Stat n="248" label="posts" /><span onClick={() => nav.go('followers')} style={{ cursor: 'pointer' }}><Stat n="38.4k" label="followers" /></span><span onClick={() => nav.go('followers')} style={{ cursor: 'pointer' }}><Stat n="612" label="following" /></span></div>
        </div>
        <div style={{ marginTop: 12 }}>
          <div style={{ fontWeight: 700, fontSize: 15 }}>Maya Oliveira</div>
          <div style={{ fontSize: 14, lineHeight: '20px', marginTop: 2 }}>Chasing light around the world 🌍 Lisbon-based · prints in bio</div>
          <div style={{ fontSize: 14, color: 'var(--violet-500)', fontWeight: 600, marginTop: 2 }}>we36.app/maya</div>
        </div>
        <div style={{ display: 'flex', gap: 8, marginTop: 14 }}>
          <Button variant="secondary" fullWidth onClick={() => nav.go('editprofile')}>Edit profile</Button>
          <Button variant="secondary" fullWidth onClick={() => nav.toast('Profile link copied')}>Share profile</Button>
        </div>
      </div>
      <ProfileTabs active={0} onTab={(i) => { if (i === 1) nav.go('collections'); }} />
      <div style={{ flex: 1, overflow: 'hidden', display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 2, padding: '2px 2px 0', background: 'var(--surface-2)' }}>
        {GRID_IDS.slice(0, 9).map((id, i) => (<div key={i} onClick={() => nav.go('postdetail')} style={{ cursor: 'pointer', aspectRatio: '1', overflow: 'hidden' }}><img src={PHOTO(id, 300, 300)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} /></div>))}
      </div>
    </Frame>
  );
}

/* D2 · Other user's profile */
function OtherProfileScreen() {
  const { Avatar, Button, Icon } = W36;
  const nav = useNav();
  return (
    <Frame bg="var(--bg-app)">
      <TopBar title="devon.shoots" back action={<span onClick={() => nav.go('actionsheet')} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="more" size={22} color="var(--icon)" /></span>} />
      <div style={{ padding: '14px 16px', background: 'var(--surface)', flexShrink: 0 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 22 }}>
          <Avatar src={IMG.devon} size={88} ring />
          <div style={{ display: 'flex', flex: 1, justifyContent: 'space-around' }}><Stat n="512" label="posts" /><span onClick={() => nav.go('followers')} style={{ cursor: 'pointer' }}><Stat n="91.2k" label="followers" /></span><span onClick={() => nav.go('followers')} style={{ cursor: 'pointer' }}><Stat n="340" label="following" /></span></div>
        </div>
        <div style={{ marginTop: 12 }}>
          <div style={{ fontWeight: 700, fontSize: 15 }}>Devon Park <span style={{ fontWeight: 400, color: 'var(--text-secondary)', fontSize: 13 }}>· Photographer</span></div>
          <div style={{ fontSize: 14, lineHeight: '20px', marginTop: 2 }}>night &amp; street 📷 tokyo → everywhere. dm for prints</div>
        </div>
        <div style={{ display: 'flex', gap: 8, marginTop: 14 }}>
          <Button variant="primary" fullWidth onClick={() => nav.toast('Following devon.shoots')}>Follow</Button>
          <Button variant="secondary" fullWidth onClick={() => nav.go('chat')}>Message</Button>
          <Button variant="secondary" style={{ width: 44, padding: 0 }} onClick={() => nav.go('actionsheet')}><Icon name="chevronLeft" size={18} color="var(--text-primary)" style={{ transform: 'rotate(-90deg)' }} /></Button>
        </div>
      </div>
      <ProfileTabs active={0} />
      <div style={{ flex: 1, overflow: 'hidden', display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 2, padding: '2px 2px 0', background: 'var(--surface-2)' }}>
        {GRID_IDS.slice(3, 12).map((id, i) => (<div key={i} onClick={() => nav.go('postdetail')} style={{ cursor: 'pointer', aspectRatio: '1', overflow: 'hidden' }}><img src={PHOTO(id, 300, 300)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} /></div>))}
      </div>
    </Frame>
  );
}

/* D3 · Followers / following list */
function FollowersScreen() {
  const { Avatar, Button, SearchBar, Icon } = W36;
  const nav = useNav();
  const people = [
    { img: IMG.aisha, name: 'aisha.k', sub: 'Aisha Khan', state: 'following' },
    { img: IMG.liam, name: 'liam', sub: 'Liam Brooks', state: 'follow' },
    { img: IMG.noor, name: 'noor.films', sub: 'Noor · Follows you', state: 'follow' },
    { img: IMG.sofia, name: 'sofia.eats', sub: 'Sofia Reyes', state: 'following' },
    { img: IMG.kai, name: 'kai', sub: 'Kai Tan', state: 'follow' },
    { img: IMG.devon, name: 'devon.shoots', sub: 'Devon Park', state: 'following' },
  ];
  return (
    <Frame bg="var(--surface)">
      <TopBar title="maya.travels" back />
      <div style={{ display: 'flex', borderBottom: '1px solid var(--divider)', flexShrink: 0 }}>
        {[['38.4k followers', true],['612 following', false]].map(([t, a], i) => <div key={i} style={{ flex: 1, textAlign: 'center', padding: '12px 0', fontSize: 14, fontWeight: a?700:500, color: a?'var(--text-primary)':'var(--text-secondary)', borderBottom: a?'2px solid var(--rose-500)':'2px solid transparent', marginBottom: -1 }}>{t}</div>)}
      </div>
      <div style={{ padding: '10px 16px', flexShrink: 0 }}><SearchBar placeholder="Search" /></div>
      <div style={{ flex: 1, overflow: 'hidden' }}>
        {people.map((p, i) => (
          <div key={i} onClick={() => nav.go('otherprofile')} style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 12, padding: '7px 16px' }}>
            <Avatar src={p.img} size={48} />
            <div style={{ flex: 1 }}><div style={{ fontSize: 15, fontWeight: 600 }}>{p.name}</div><div style={{ fontSize: 13, color: 'var(--text-secondary)' }}>{p.sub}</div></div>
            <Button variant={p.state === 'following' ? 'secondary' : 'primary'} size="sm" style={{ minWidth: 96 }}>{p.state === 'following' ? 'Following' : 'Follow'}</Button>
          </div>
        ))}
      </div>
    </Frame>
  );
}

/* D4 · Edit profile */
function EditProfileScreen() {
  const { Avatar, Icon } = W36;
  const nav = useNav();
  const Row = ({ label, value, sub }) => (
    <div style={{ display: 'flex', alignItems: 'center', gap: 14, padding: '14px 16px', borderBottom: '1px solid var(--divider)' }}>
      <span style={{ width: 96, fontSize: 14, color: 'var(--text-secondary)', fontWeight: 600, flexShrink: 0 }}>{label}</span>
      <span style={{ flex: 1, fontSize: 15, color: value ? 'var(--text-primary)' : 'var(--text-tertiary)' }}>{value || sub}</span>
    </div>
  );
  return (
    <Frame bg="var(--surface)">
      <TopBar title="Edit profile" back action={<span onClick={() => { nav.toast('Profile updated'); nav.back(); }} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="check" size={24} color="var(--rose-500)" /></span>} />
      <div style={{ flex: 1, overflow: 'hidden' }}>
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8, padding: '20px 0' }}>
          <Avatar src={IMG.maya} size={88} />
          <span style={{ color: 'var(--rose-500)', fontWeight: 700, fontSize: 14 }}>Change profile photo</span>
        </div>
        <Row label="Name" value="Maya Oliveira" />
        <Row label="Username" value="maya.travels" />
        <Row label="Pronouns" value="she/her" />
        <Row label="Website" value="we36.app/maya" />
        <Row label="Bio" value="Chasing light around the world 🌍" />
        <div style={{ padding: '16px' }}>
          <span style={{ fontSize: 13, fontWeight: 700, color: 'var(--text-secondary)' }}>Professional</span>
        </div>
        <Row label="Category" sub="Photography" />
        <Row label="Contact" sub="Email · Phone" />
      </div>
    </Frame>
  );
}

/* D5 · Saved collections */
function CollectionsScreen() {
  const { Icon } = W36;
  const nav = useNav();
  const cols = [
    { name: 'travel', count: 64, ids: GRID_IDS.slice(0, 4) },
    { name: 'food', count: 28, ids: GRID_IDS.slice(4, 8) },
    { name: 'design', count: 41, ids: GRID_IDS.slice(2, 6) },
    { name: 'fits', count: 12, ids: GRID_IDS.slice(6, 10) },
  ];
  return (
    <Frame bg="var(--bg-app)">
      <TopBar title="Saved" back action={<Icon name="plus" size={24} color="var(--icon)" />} />
      <div style={{ flex: 1, overflow: 'hidden', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14, padding: 16 }}>
        {cols.map((c, i) => (
          <div key={i} onClick={() => nav.go('postdetail')} style={{ cursor: 'pointer' }}>
            <div style={{ aspectRatio: '1', borderRadius: 16, overflow: 'hidden', display: 'grid', gridTemplateColumns: '1fr 1fr', gridTemplateRows: '1fr 1fr', gap: 2, background: 'var(--surface-2)' }}>
              {c.ids.map((id, j) => <img key={j} src={PHOTO(id, 200, 200)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />)}
            </div>
            <div style={{ fontWeight: 700, fontSize: 15, marginTop: 8 }}>{c.name}</div>
            <div style={{ fontSize: 13, color: 'var(--text-secondary)' }}>{c.count} saved</div>
          </div>
        ))}
      </div>
    </Frame>
  );
}

Object.assign(window, { MyProfileScreen, OtherProfileScreen, FollowersScreen, EditProfileScreen, CollectionsScreen });

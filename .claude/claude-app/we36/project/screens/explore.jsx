/* We36 — C. Explore & Search screens */

/* C1 · Explore grid */
function ExploreScreen() {
  const { SearchBar, Tag, BottomNav, Icon } = W36;
  const nav = useNav();
  const tags = [['For you', true],['travel'],['food'],['design'],['fitness']];
  return (
    <Frame bg="var(--bg-app)" nav={<BottomNav active="search" onChange={nav.tab} badges={{ message: 3 }} />}>
      <div style={{ padding: '10px 16px', background: 'var(--surface)', borderBottom: '1px solid var(--divider)', flexShrink: 0 }}>
        <div onClick={() => nav.go('search')} style={{ cursor: 'pointer' }}><SearchBar placeholder="Search people, tags, places" /></div>
        <div style={{ display: 'flex', gap: 8, marginTop: 12, overflowX: 'hidden' }}>
          {tags.map(([l, a], i) => <Tag key={i} active={a} hashtag={i > 0} onClick={i > 0 ? () => nav.go('hashtag') : undefined} style={{ flexShrink: 0 }}>{l}</Tag>)}
        </div>
      </div>
      <div style={{ flex: 1, overflow: 'hidden', display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gridAutoRows: '124px', gap: 2, padding: 2, background: 'var(--surface-2)' }}>
        {GRID_IDS.map((id, i) => (
          <div key={i} onClick={() => nav.go('postdetail')} style={{ cursor: 'pointer', overflow: 'hidden', position: 'relative', gridRow: i === 1 ? 'span 2' : 'span 1', gridColumn: i === 1 ? 'span 2' : 'span 1' }}>
            <img src={PHOTO(id, 400, 400)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
            {i === 4 && <span style={{ position: 'absolute', top: 6, right: 6 }}><Icon name="reels" size={18} color="#fff" solid /></span>}
          </div>
        ))}
      </div>
    </Frame>
  );
}

/* C2 · Search (recent + suggestions) */
function SearchScreen() {
  const { SearchBar, Avatar, Icon } = W36;
  const nav = useNav();
  const recents = [
    { img: IMG.maya, name: 'maya.travels', sub: 'Maya Oliveira', kind: 'user' },
    { img: null, name: '#goldenhour', sub: '1.2M posts', kind: 'tag' },
    { img: null, name: 'Lisbon, Portugal', sub: 'Location', kind: 'place' },
    { img: IMG.devon, name: 'devon.shoots', sub: 'Devon · Following', kind: 'user' },
  ];
  return (
    <Frame bg="var(--surface)">
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '8px 12px', flexShrink: 0 }}>
        <span onClick={nav.back} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="chevronLeft" size={26} color="var(--text-primary)" /></span>
        <div onClick={() => nav.go('results')} style={{ cursor: 'pointer', flex: 1 }}><SearchBar placeholder="Search" /></div>
      </div>
      <div style={{ flex: 1, overflow: 'hidden' }}>
        <div style={{ display: 'flex', alignItems: 'center', padding: '12px 16px 6px' }}>
          <span style={{ fontWeight: 700, fontSize: 14 }}>Recent</span>
          <span style={{ marginLeft: 'auto', color: 'var(--rose-500)', fontSize: 13, fontWeight: 600 }}>Clear all</span>
        </div>
        {recents.map((r, i) => (
          <div key={i} onClick={() => nav.go(r.kind === 'user' ? 'otherprofile' : r.kind === 'tag' ? 'hashtag' : 'results')} style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 12, padding: '10px 16px' }}>
            {r.kind === 'user'
              ? <Avatar src={r.img} size={44} />
              : <span style={{ width: 44, height: 44, borderRadius: '50%', background: 'var(--surface-2)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}><Icon name={r.kind === 'tag' ? 'search' : 'search'} size={20} color="var(--icon)" />{r.kind==='tag' && <span style={{ position: 'absolute', fontWeight: 800, color: 'var(--violet-500)', fontSize: 18 }}></span>}</span>}
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 15, fontWeight: 600 }}>{r.name}</div>
              <div style={{ fontSize: 13, color: 'var(--text-secondary)' }}>{r.sub}</div>
            </div>
            <Icon name="x" size={18} color="var(--icon)" />
          </div>
        ))}
      </div>
    </Frame>
  );
}

/* C3 · Search results (tabs) */
function SearchResultsScreen() {
  const { SearchBar, Avatar, Button, Icon, Tag } = W36;
  const nav = useNav();
  const tabs = ['Top','Accounts','Tags','Places'];
  const accounts = [
    { img: IMG.maya, name: 'maya.travels', sub: 'Maya · 38.4k followers', follow: true },
    { img: IMG.noor, name: 'noor.films', sub: 'Noor · 12.1k followers', follow: false },
    { img: IMG.sofia, name: 'sofia.eats', sub: 'Sofia · 4,210 followers', follow: true },
  ];
  return (
    <Frame bg="var(--surface)">
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '8px 12px', flexShrink: 0 }}>
        <span onClick={nav.back} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="chevronLeft" size={26} color="var(--text-primary)" /></span>
        <div style={{ flex: 1 }}><SearchBar placeholder="Search" value="maya" onChange={()=>{}} /></div>
      </div>
      <div style={{ display: 'flex', gap: 22, padding: '0 16px', borderBottom: '1px solid var(--divider)', flexShrink: 0 }}>
        {tabs.map((t, i) => (
          <div key={t} style={{ padding: '12px 0', fontSize: 14, fontWeight: i === 0 ? 700 : 500, color: i === 0 ? 'var(--text-primary)' : 'var(--text-secondary)', borderBottom: i === 0 ? '2px solid var(--rose-500)' : '2px solid transparent', marginBottom: -1 }}>{t}</div>
        ))}
      </div>
      <div style={{ flex: 1, overflow: 'hidden' }}>
        <div style={{ display: 'flex', gap: 8, padding: '12px 16px', overflowX: 'hidden' }}>
          <Tag active hashtag onClick={() => nav.go('hashtag')}>maya</Tag><Tag hashtag onClick={() => nav.go('hashtag')}>mayatravels</Tag><Tag hashtag onClick={() => nav.go('hashtag')}>mayalisbon</Tag>
        </div>
        {accounts.map((a, i) => (
          <div key={i} onClick={() => nav.go('otherprofile')} style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 12, padding: '8px 16px' }}>
            <Avatar src={a.img} size={48} ring={i===0} />
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 15, fontWeight: 600 }}>{a.name}</div>
              <div style={{ fontSize: 13, color: 'var(--text-secondary)' }}>{a.sub}</div>
            </div>
            <Button variant={a.follow ? 'secondary' : 'primary'} size="sm" style={{ minWidth: 92 }}>{a.follow ? 'Following' : 'Follow'}</Button>
          </div>
        ))}
      </div>
    </Frame>
  );
}

/* C4 · Hashtag / location page */
function HashtagScreen() {
  const { Button, Icon } = W36;
  const nav = useNav();
  return (
    <Frame bg="var(--bg-app)">
      <TopBar title="Tag" back action={<Icon name="more" size={22} color="var(--icon)" />} />
      <div style={{ display: 'flex', alignItems: 'center', gap: 14, padding: '16px', background: 'var(--surface)', borderBottom: '1px solid var(--divider)', flexShrink: 0 }}>
        <div style={{ width: 72, height: 72, borderRadius: '50%', background: 'var(--gradient-brand-soft)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: 'var(--font-display)', fontWeight: 800, fontSize: 34, color: '#fff' }}>#</div>
        <div style={{ flex: 1 }}>
          <div style={{ fontFamily: 'var(--font-display)', fontWeight: 800, fontSize: 22 }}>#goldenhour</div>
          <div style={{ fontSize: 13, color: 'var(--text-secondary)', marginTop: 2 }}>1.2M posts</div>
        </div>
        <Button variant="primary" size="sm" onClick={() => nav.toast('Following #goldenhour')}>Follow</Button>
      </div>
      <div style={{ display: 'flex', gap: 22, padding: '0 16px', background: 'var(--surface)', borderBottom: '1px solid var(--divider)', flexShrink: 0 }}>
        {['Top','Recent','Reels'].map((t, i) => <div key={t} style={{ padding: '11px 0', fontSize: 14, fontWeight: i===0?700:500, color: i===0?'var(--text-primary)':'var(--text-secondary)', borderBottom: i===0?'2px solid var(--rose-500)':'2px solid transparent', marginBottom: -1 }}>{t}</div>)}
      </div>
      <div style={{ flex: 1, overflow: 'hidden', display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 2, padding: 2, background: 'var(--surface-2)' }}>
        {GRID_IDS.map((id, i) => (<div key={i} onClick={() => nav.go('postdetail')} style={{ cursor: 'pointer', aspectRatio: '1', overflow: 'hidden' }}><img src={PHOTO(id, 300, 300)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} /></div>))}
      </div>
    </Frame>
  );
}

Object.assign(window, { ExploreScreen, SearchScreen, SearchResultsScreen, HashtagScreen });

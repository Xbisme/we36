/* We36 — B. Feed & Content screens */

const STORIES = [
  { user: 'Your story', me: true, img: IMG.kai },
  { user: 'maya', img: IMG.maya },
  { user: 'devon', img: IMG.devon },
  { user: 'aisha', seen: true, img: IMG.aisha },
  { user: 'liam', img: IMG.liam },
];

function StoriesRail() {
  const { Avatar, Icon } = W36;
  const nav = useNav();
  return (
    <div style={{ display: 'flex', gap: 14, padding: '12px 16px', overflowX: 'hidden', background: 'var(--surface)', borderBottom: '1px solid var(--divider)', flexShrink: 0 }}>
      {STORIES.map((s, i) => (
        <div key={i} onClick={() => nav.go(s.me ? 'createstory' : 'story')} style={{ cursor: 'pointer', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6, flexShrink: 0, width: 60 }}>
          <div style={{ position: 'relative' }}>
            <Avatar src={s.img} size={56} ring={!s.me} seen={s.seen} />
            {s.me && <span style={{ position: 'absolute', right: -2, bottom: -2, width: 22, height: 22, borderRadius: '50%', background: 'var(--gradient-brand)', display: 'flex', alignItems: 'center', justifyContent: 'center', border: '2px solid var(--surface)' }}><Icon name="plus" size={13} color="#fff" /></span>}
          </div>
          <span style={{ fontSize: 11, color: 'var(--text-secondary)', maxWidth: 60, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{s.user}</span>
        </div>
      ))}
    </div>
  );
}

/* B1 · Home feed */
function HomeFeedScreen() {
  const { IconButton, PostCard, BottomNav } = W36;
  const nav = useNav();
  return (
    <Frame bg="var(--bg-app)" nav={<BottomNav active="home" onChange={nav.tab} badges={{ message: 3 }} />}>
      <header style={{ display: 'flex', alignItems: 'center', padding: '0 16px', height: 52, background: 'var(--surface)', borderBottom: '1px solid var(--divider)', flexShrink: 0 }}>
        <Wordmark size={24} />
        <div style={{ marginLeft: 'auto', display: 'flex', gap: 2 }}>
          <span onClick={() => nav.go('notifications')} style={{ cursor: 'pointer', position: 'relative' }}><IconButton name="notification" label="Activity" /><span style={{ position: 'absolute', top: 6, right: 6, width: 9, height: 9, borderRadius: '50%', background: 'var(--rose-500)', border: '2px solid var(--surface)', pointerEvents: 'none' }} /></span>
          <span onClick={() => nav.go('dmlist')} style={{ cursor: 'pointer' }}><IconButton name="message" label="Messages" /></span>
        </div>
      </header>
      <StoriesRail />
      <div onClick={() => nav.go('postdetail')} style={{ cursor: 'pointer', flex: 1, overflow: 'hidden', padding: '12px 8px 0' }}>
        <PostCard user="maya.travels" avatar={IMG.maya} location="Lisbon, Portugal" image={PHOTO('photo-1513735492246-483525079686', 900, 1100)} likes={1240} caption="golden hour never misses ☀️ #goldenhour" comments={86} time="2h" style={{ maxWidth: '100%' }} />
      </div>
    </Frame>
  );
}

/* B2 · Story viewer */
function StoryViewerScreen() {
  const { Avatar, Icon } = W36;
  const nav = useNav();
  return (
    <Frame dark bg="#000" noStatus>
      <div style={{ position: 'relative', flex: 1, overflow: 'hidden' }}>
        <img src={PHOTO('photo-1469474968028-56623f02e42e', 800, 1500)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
        {/* progress */}
        <div style={{ position: 'absolute', top: 12, left: 12, right: 12, display: 'flex', gap: 4 }}>
          {[1,0.4,0].map((p,i)=>(<div key={i} style={{ flex: 1, height: 3, borderRadius: 2, background: 'rgba(255,255,255,.35)' }}><div style={{ width: `${p*100}%`, height: '100%', borderRadius: 2, background: '#fff' }} /></div>))}
        </div>
        <div style={{ position: 'absolute', top: 26, left: 12, right: 12, display: 'flex', alignItems: 'center', gap: 10 }}>
          <Avatar src={IMG.maya} size={36} />
          <span style={{ color: '#fff', fontWeight: 700, fontSize: 14 }}>maya.travels</span>
          <span style={{ color: 'rgba(255,255,255,.7)', fontSize: 13 }}>2h</span>
          <span onClick={nav.back} style={{ cursor: 'pointer', marginLeft: 'auto', display: 'flex' }}><Icon name="x" size={24} color="#fff" /></span>
        </div>
        <div style={{ position: 'absolute', left: 0, right: 0, bottom: 0, height: 140, background: 'linear-gradient(to top, rgba(0,0,0,.5), transparent)' }} />
        <div style={{ position: 'absolute', left: 12, right: 12, bottom: 20, display: 'flex', alignItems: 'center', gap: 10 }}>
          <div style={{ flex: 1, height: 44, borderRadius: 999, border: '1.5px solid rgba(255,255,255,.6)', display: 'flex', alignItems: 'center', padding: '0 16px', color: 'rgba(255,255,255,.8)', fontSize: 14 }}>Send message</div>
          <Icon name="like" size={26} color="#fff" />
          <Icon name="share" size={26} color="#fff" />
        </div>
      </div>
    </Frame>
  );
}

/* B3 · Create story */
function CreateStoryScreen() {
  const { Icon, Button } = W36;
  const nav = useNav();
  const tools = ['camera','plus','more','settings'];
  return (
    <Frame dark bg="#000" noStatus>
      <div style={{ position: 'relative', flex: 1, overflow: 'hidden' }}>
        <img src={PHOTO('photo-1500534314209-a25ddb2bd429', 800, 1500)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover', opacity: .96 }} />
        <div style={{ position: 'absolute', top: 20, left: 16, right: 16, display: 'flex', alignItems: 'center' }}>
          <span onClick={nav.back} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="x" size={26} color="#fff" /></span>
          <div style={{ marginLeft: 'auto', display: 'flex', gap: 14 }}>
            {tools.map(t => <span key={t} style={{ width: 40, height: 40, borderRadius: '50%', background: 'rgba(0,0,0,.35)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}><Icon name={t} size={20} color="#fff" /></span>)}
          </div>
        </div>
        {/* sticker preview */}
        <div style={{ position: 'absolute', top: '38%', left: '50%', transform: 'translateX(-50%) rotate(-4deg)', background: 'var(--gradient-brand)', color: '#fff', fontWeight: 800, fontFamily: 'var(--font-display)', fontSize: 20, padding: '8px 18px', borderRadius: 999, boxShadow: '0 6px 20px rgba(0,0,0,.3)' }}>lisbon ☀️</div>
        <div style={{ position: 'absolute', left: 0, right: 0, bottom: 0, height: 130, background: 'linear-gradient(to top, rgba(0,0,0,.55), transparent)' }} />
        <div style={{ position: 'absolute', left: 16, right: 16, bottom: 22, display: 'flex', alignItems: 'center', gap: 12 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, background: 'rgba(255,255,255,.18)', borderRadius: 999, padding: '8px 14px', color: '#fff', fontSize: 14, fontWeight: 600 }}><Icon name="profile" size={18} color="#fff" />Your story</div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, background: 'rgba(255,255,255,.18)', borderRadius: 999, padding: '8px 14px', color: '#fff', fontSize: 14, fontWeight: 600 }}>Close friends</div>
          <span style={{ marginLeft: 'auto', width: 54, height: 54, borderRadius: '50%', background: 'var(--gradient-brand)', display: 'flex', alignItems: 'center', justifyContent: 'center', boxShadow: 'var(--shadow-brand, 0 6px 20px rgba(255,78,100,.5))', cursor: 'pointer' }} onClick={() => { nav.toast('Story shared'); nav.tab('home'); }}><Icon name="share" size={24} color="#fff" /></span>
        </div>
      </div>
    </Frame>
  );
}

/* B4 · Reels */
function ReelsScreen() {
  const { Avatar, Icon, Button, BottomNav } = W36;
  const nav = useNav();
  const Action = ({ name, count, active }) => (
    <div onClick={name === 'comment' ? () => nav.go('comments') : name === 'share' ? () => nav.go('actionsheet') : undefined} style={{ cursor: 'pointer', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, color: '#fff' }}>
      <Icon name={name} size={30} color={active ? 'var(--rose-500)' : '#fff'} solid={active} />
      {count != null && <span style={{ fontSize: 12, fontWeight: 600 }}>{count}</span>}
    </div>
  );
  return (
    <Frame dark bg="#000" noStatus nav={<BottomNav active="reels" onChange={nav.tab} badges={{ message: 3 }} />}>
      <div style={{ position: 'relative', flex: 1, overflow: 'hidden' }}>
        <img src={PHOTO('photo-1518609878373-06d740f60d8b', 800, 1500)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover', opacity: .92 }} />
        <div style={{ position: 'absolute', top: 18, left: 16, right: 16, display: 'flex', alignItems: 'center' }}>
          <span style={{ fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 18, color: '#fff' }}>Reels</span>
          <span onClick={() => nav.go('createstory')} style={{ cursor: 'pointer', display: 'flex', marginLeft: 'auto' }}><Icon name="camera" size={24} color="#fff" /></span>
        </div>
        <div style={{ position: 'absolute', right: 12, bottom: 40, display: 'flex', flexDirection: 'column', gap: 20, alignItems: 'center' }}>
          <Action name="like" count="24.1k" active />
          <Action name="comment" count="318" />
          <Action name="share" count="1.2k" />
          <Action name="save" />
          <span onClick={() => nav.go('actionsheet')} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="more" size={26} color="#fff" /></span>
        </div>
        <div style={{ position: 'absolute', left: 16, right: 80, bottom: 30, color: '#fff' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 10 }}>
            <Avatar src={IMG.devon} size={36} />
            <span style={{ fontWeight: 700, fontSize: 14 }}>devon.shoots</span>
            <Button variant="secondary" size="sm" style={{ height: 30, background: 'transparent', color: '#fff', borderColor: 'rgba(255,255,255,.7)' }} onClick={() => nav.toast('Following devon.shoots')}>Follow</Button>
          </div>
          <div style={{ fontSize: 14, lineHeight: '20px', textShadow: '0 1px 8px rgba(0,0,0,.5)' }}>cinematic walk through the old town 🎬 <span style={{ fontWeight: 600 }}>#reels #travel</span></div>
        </div>
        <div style={{ position: 'absolute', left: 0, right: 0, bottom: 0, height: 160, background: 'linear-gradient(to top, rgba(0,0,0,.55), transparent)', pointerEvents: 'none' }} />
      </div>
    </Frame>
  );
}

/* B5a · Create post — pick media */
function CreatePickScreen() {
  const { Icon } = W36;
  const nav = useNav();
  return (
    <Frame bg="var(--surface)">
      <TopBar title="New post" back action={<span onClick={() => nav.go('createedit')} style={{ cursor: 'pointer', color: 'var(--rose-500)', fontWeight: 700, fontSize: 15 }}>Next</span>} />
      <div style={{ aspectRatio: '1', background: 'var(--surface-2)', overflow: 'hidden', flexShrink: 0, position: 'relative' }}>
        <img src={PHOTO('photo-1441974231531-c6227db76b6e', 800, 800)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
        <span style={{ position: 'absolute', top: 12, right: 12, background: 'rgba(26,26,46,.55)', color: '#fff', borderRadius: 999, padding: '4px 10px', fontSize: 12, fontWeight: 600, display: 'flex', gap: 4, alignItems: 'center' }}><Icon name="plus" size={14} color="#fff" />Carousel</span>
      </div>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '10px 16px', flexShrink: 0 }}>
        <span style={{ fontWeight: 700, fontSize: 14 }}>Recents</span>
        <div style={{ display: 'flex', gap: 12 }}><Icon name="camera" size={22} color="var(--icon)" /><Icon name="reels" size={22} color="var(--icon)" /></div>
      </div>
      <div style={{ flex: 1, overflow: 'hidden', display: 'grid', gridTemplateColumns: 'repeat(4,1fr)', gap: 2, background: 'var(--surface-2)' }}>
        {GRID_IDS.concat(GRID_IDS).slice(0, 16).map((id, i) => (
          <div key={i} style={{ aspectRatio: '1', overflow: 'hidden', position: 'relative', outline: i===0 ? '3px solid var(--rose-500)' : 'none', outlineOffset: -3 }}>
            <img src={PHOTO(id, 200, 200)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
            {i===0 && <span style={{ position: 'absolute', top: 6, right: 6, width: 20, height: 20, borderRadius: '50%', background: 'var(--gradient-brand)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}><Icon name="check" size={13} color="#fff" /></span>}
          </div>
        ))}
      </div>
    </Frame>
  );
}

/* B5b · Create post — edit / filter */
function CreateEditScreen() {
  const { Icon } = W36;
  const nav = useNav();
  const filters = [['Original',false],['Warm',true],['Lux',false],['Mono',false],['Fade',false]];
  return (
    <Frame bg="var(--surface)">
      <TopBar title="Edit" back action={<span onClick={() => nav.go('createcaption')} style={{ cursor: 'pointer', color: 'var(--rose-500)', fontWeight: 700, fontSize: 15 }}>Next</span>} />
      <div style={{ aspectRatio: '1', overflow: 'hidden', flexShrink: 0 }}>
        <img src={PHOTO('photo-1441974231531-c6227db76b6e', 800, 800)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover', filter: 'saturate(1.2) contrast(1.05) brightness(1.03)' }} />
      </div>
      <div style={{ display: 'flex', gap: 10, padding: '14px 16px', overflowX: 'hidden', flexShrink: 0 }}>
        {filters.map(([name, active], i) => (
          <div key={i} style={{ flexShrink: 0, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6 }}>
            <div style={{ width: 64, height: 64, borderRadius: 12, overflow: 'hidden', border: active ? '2px solid var(--rose-500)' : '2px solid transparent' }}>
              <img src={PHOTO('photo-1441974231531-c6227db76b6e', 120, 120)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover', filter: active ? 'saturate(1.4) sepia(.15)' : 'none' }} />
            </div>
            <span style={{ fontSize: 11, fontWeight: active ? 700 : 500, color: active ? 'var(--rose-500)' : 'var(--text-secondary)' }}>{name}</span>
          </div>
        ))}
      </div>
      <div style={{ borderTop: '1px solid var(--divider)', padding: '12px 16px', display: 'flex', flexDirection: 'column', gap: 14, flex: 1 }}>
        {[['Brightness', 0.62],['Contrast', 0.5],['Warmth', 0.74]].map(([label, v]) => (
          <div key={label}>
            <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 13, marginBottom: 8 }}><span style={{ color: 'var(--text-secondary)', fontWeight: 600 }}>{label}</span><span style={{ color: 'var(--text-primary)', fontWeight: 700 }}>{Math.round(v*100)}</span></div>
            <div style={{ height: 4, borderRadius: 2, background: 'var(--surface-2)', position: 'relative' }}><div style={{ width: `${v*100}%`, height: '100%', borderRadius: 2, background: 'var(--gradient-brand)' }} /><span style={{ position: 'absolute', left: `calc(${v*100}% - 8px)`, top: -6, width: 16, height: 16, borderRadius: '50%', background: '#fff', boxShadow: '0 1px 4px rgba(26,26,46,.3)', border: '1px solid var(--border)' }} /></div>
          </div>
        ))}
        <div style={{ display: 'flex', gap: 18, marginTop: 4 }}>
          {['camera','more','plus'].map(t => <span key={t} style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 13, fontWeight: 600, color: 'var(--text-secondary)' }}><Icon name={t} size={20} color="var(--icon)" /></span>)}
        </div>
      </div>
    </Frame>
  );
}

/* B5c · Create post — caption & tag */
function CreateCaptionScreen() {
  const { Icon, Switch } = W36;
  const nav = useNav();
  const Row = ({ icon, label, value }) => (
    <div style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '14px 0', borderBottom: '1px solid var(--divider)' }}>
      <Icon name={icon} size={20} color="var(--icon)" />
      <span style={{ fontSize: 15, fontWeight: 500 }}>{label}</span>
      <span style={{ marginLeft: 'auto', color: 'var(--text-secondary)', fontSize: 14, display: 'flex', alignItems: 'center', gap: 6 }}>{value}<Icon name="chevronLeft" size={18} color="var(--icon)" style={{ transform: 'scaleX(-1)' }} /></span>
    </div>
  );
  return (
    <Frame bg="var(--surface)">
      <TopBar title="New post" back action={<span onClick={() => { nav.toast('Your post was shared'); nav.tab('home'); }} style={{ cursor: 'pointer', color: 'var(--rose-500)', fontWeight: 800, fontSize: 15 }}>Share</span>} />
      <div style={{ flex: 1, overflow: 'hidden', padding: '0 16px' }}>
        <div style={{ display: 'flex', gap: 12, padding: '14px 0' }}>
          <div style={{ width: 72, height: 72, borderRadius: 10, overflow: 'hidden', flexShrink: 0 }}><img src={PHOTO('photo-1441974231531-c6227db76b6e', 150, 150)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} /></div>
          <div style={{ flex: 1, fontSize: 15, color: 'var(--text-primary)', lineHeight: '21px' }}>golden hour in the alfama 🌅 <span style={{ color: 'var(--violet-500)', fontWeight: 600 }}>#lisbon #goldenhour #travel</span></div>
        </div>
        <Row icon="profile" label="Tag people" value="2 tagged" />
        <Row icon="search" label="Add location" value="Alfama, Lisbon" />
        <Row icon="message" label="Add music" value="Add" />
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '14px 0', borderBottom: '1px solid var(--divider)' }}>
          <Icon name="profile" size={20} color="var(--icon)" />
          <div><div style={{ fontSize: 15, fontWeight: 500 }}>Also share to</div><div style={{ fontSize: 12, color: 'var(--text-tertiary)' }}>Stories</div></div>
          <span style={{ marginLeft: 'auto' }}><Switch checked /></span>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '14px 0' }}>
          <Icon name="comment" size={20} color="var(--icon)" />
          <span style={{ fontSize: 15, fontWeight: 500 }}>Turn off commenting</span>
          <span style={{ marginLeft: 'auto' }}><Switch /></span>
        </div>
      </div>
    </Frame>
  );
}

/* B6 · Post detail */
function PostDetailScreen() {
  const { PostCard, Avatar, Icon } = W36;
  const nav = useNav();
  return (
    <Frame bg="var(--bg-app)">
      <TopBar title="Post" back action={<span onClick={() => nav.go('actionsheet')} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="more" size={22} color="var(--icon)" /></span>} />
      <div style={{ flex: 1, overflow: 'hidden', padding: '12px 8px 0' }}>
        <PostCard user="devon.shoots" avatar={IMG.devon} location="Tokyo, Japan" image={PHOTO('photo-1542051841857-5f90071e7989', 900, 1100)} likes={873} caption="neon nights in Shibuya 🌃 #tokyo #nightphotography" comments={41} time="5h" style={{ maxWidth: '100%' }} />
        <div onClick={() => nav.go('comments')} style={{ cursor: 'pointer', padding: '4px 14px 16px', color: 'var(--text-secondary)', fontSize: 14 }}>View all 41 comments</div>
      </div>
    </Frame>
  );
}

/* B7 · Comments */
function CommentsScreen() {
  const { Avatar, Icon } = W36;
  const nav = useNav();
  const C = ({ img, user, text, time, likes, reply, liked }) => (
    <div style={{ display: 'flex', gap: 10, padding: reply ? '8px 0 8px 40px' : '10px 0' }}>
      <Avatar src={img} size={reply ? 28 : 34} />
      <div style={{ flex: 1 }}>
        <div style={{ fontSize: 14, lineHeight: '19px' }}><span style={{ fontWeight: 700 }}>{user}</span> {text}</div>
        <div style={{ display: 'flex', gap: 16, marginTop: 5, fontSize: 12, color: 'var(--text-tertiary)', fontWeight: 600 }}><span>{time}</span><span>{likes} likes</span><span>Reply</span></div>
      </div>
      <Icon name="like" size={15} color={liked ? 'var(--rose-500)' : 'var(--icon)'} solid={liked} style={{ marginTop: 4 }} />
    </div>
  );
  return (
    <Frame bg="var(--surface)">
      <TopBar title="Comments" back />
      <div style={{ flex: 1, overflow: 'hidden', padding: '4px 16px' }}>
        <C img={IMG.aisha} user="aisha.k" text="this is unreal 😍 what lens?" time="2h" likes={12} liked />
        <C img={IMG.devon} user="devon.shoots" text="35mm, golden hour magic ✨" time="1h" likes={4} reply />
        <C img={IMG.liam} user="liam" text="saving this for inspo 🔥" time="3h" likes={8} />
        <C img={IMG.noor} user="noor.films" text="the colors here are perfect" time="4h" likes={21} />
        <C img={IMG.sofia} user="sofia" text="okay this is my new wallpaper" time="5h" likes={2} />
      </div>
      <div style={{ display: 'flex', gap: 14, padding: '8px 16px 4px', borderTop: '1px solid var(--divider)', flexShrink: 0 }}>
        {['❤️','🙌','🔥','👏','😍','😮','😂'].map((e, i) => <span key={i} style={{ fontSize: 24, lineHeight: 1 }}>{e}</span>)}
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '6px 14px 12px', flexShrink: 0 }}>
        <Avatar src={IMG.maya} size={32} />
        <div onClick={() => nav.go('stickers')} style={{ cursor: 'pointer', flex: 1, height: 40, borderRadius: 999, background: 'var(--surface-2)', display: 'flex', alignItems: 'center', padding: '0 12px 0 14px', gap: 8 }}>
          <span style={{ flex: 1, color: 'var(--text-tertiary)', fontSize: 14 }}>Add a comment…</span>
          <StickerGlyph size={22} color="var(--icon)" />
        </div>
        <span style={{ color: 'var(--rose-500)', fontWeight: 700, fontSize: 14 }}>Post</span>
      </div>
    </Frame>
  );
}

Object.assign(window, { HomeFeedScreen, StoryViewerScreen, CreateStoryScreen, ReelsScreen, CreatePickScreen, CreateEditScreen, CreateCaptionScreen, PostDetailScreen, CommentsScreen });

/* We36 — E. Messaging (DM) screens */

/* E1 · Conversation list */
function DMListScreen() {
  const { Avatar, SearchBar, Icon } = W36;
  const nav = useNav();
  const chats = [
    { img: IMG.devon, name: 'devon.shoots', msg: 'sent the raw files 📁', time: '2m', unread: true, online: true },
    { img: IMG.aisha, name: 'aisha.k', msg: 'haha that reel 😂', time: '18m', unread: true },
    { img: IMG.maya, name: 'maya.travels', msg: 'You: see you in lisbon!', time: '1h' },
    { img: IMG.noor, name: 'noor.films', msg: 'shared a post', time: '3h', online: true },
    { img: IMG.liam, name: 'liam', msg: 'thanks for the follow 🙌', time: '1d' },
    { img: IMG.sofia, name: 'sofia.eats', msg: 'Typing…', time: '2d', typing: true },
  ];
  return (
    <Frame bg="var(--surface)">
      <header style={{ display: 'flex', alignItems: 'center', padding: '0 12px', height: 52, flexShrink: 0 }}>
        <span onClick={() => nav.tab('home')} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="chevronLeft" size={26} color="var(--text-primary)" /></span>
        <span style={{ fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 18, marginLeft: 6 }}>maya.travels</span>
        <span onClick={() => nav.go('newmessage')} style={{ cursor: 'pointer', display: 'flex', marginLeft: 'auto' }}><Icon name="plus" size={24} color="var(--icon)" /></span>
      </header>
      <div style={{ padding: '4px 16px 10px', flexShrink: 0 }}><SearchBar placeholder="Search messages" /></div>
      {/* active rail */}
      <div style={{ display: 'flex', gap: 16, padding: '4px 16px 12px', overflowX: 'hidden', borderBottom: '1px solid var(--divider)', flexShrink: 0 }}>
        {[IMG.kai, IMG.devon, IMG.noor, IMG.liam].map((img, i) => (
          <div key={i} onClick={() => nav.go(i === 0 ? 'createstory' : 'chat')} style={{ cursor: 'pointer', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, width: 56 }}>
            <Avatar src={img} size={52} online={i < 2} />
            <span style={{ fontSize: 11, color: 'var(--text-secondary)' }}>{['you','devon','noor','liam'][i]}</span>
          </div>
        ))}
      </div>
      <div style={{ flex: 1, overflow: 'hidden' }}>
        {chats.map((c, i) => (
          <div key={i} onClick={() => nav.go('chat')} style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 12, padding: '9px 16px' }}>
            <Avatar src={c.img} size={52} online={c.online} />
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ fontSize: 15, fontWeight: c.unread ? 700 : 600 }}>{c.name}</div>
              <div style={{ fontSize: 13, color: c.typing ? 'var(--mint-500)' : c.unread ? 'var(--text-primary)' : 'var(--text-secondary)', fontWeight: c.unread ? 600 : 400, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{c.msg} · {c.time}</div>
            </div>
            {c.unread ? <span style={{ width: 9, height: 9, borderRadius: '50%', background: 'var(--rose-500)' }} /> : <Icon name="camera" size={22} color="var(--icon)" />}
          </div>
        ))}
      </div>
    </Frame>
  );
}

/* E2 · 1-1 chat */
function ChatScreen() {
  const { Avatar, Icon } = W36;
  const nav = useNav();
  const Bubble = ({ me, children, tail }) => (
    <div style={{ alignSelf: me ? 'flex-end' : 'flex-start', maxWidth: '74%', background: me ? 'var(--gradient-brand)' : 'var(--surface-2)', color: me ? '#fff' : 'var(--text-primary)', padding: '9px 14px', borderRadius: 20, borderBottomRightRadius: me && tail ? 6 : 20, borderBottomLeftRadius: !me && tail ? 6 : 20, fontSize: 14, lineHeight: '20px' }}>{children}</div>
  );
  return (
    <Frame bg="var(--surface)">
      <header style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '0 12px', height: 56, borderBottom: '1px solid var(--divider)', flexShrink: 0 }}>
        <span onClick={() => nav.go('dmlist')} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="chevronLeft" size={26} color="var(--text-primary)" /></span>
        <Avatar src={IMG.devon} size={36} online />
        <div><div style={{ fontSize: 15, fontWeight: 700 }}>devon.shoots</div><div style={{ fontSize: 12, color: 'var(--mint-500)' }}>Active now</div></div>
        <div style={{ marginLeft: 'auto', display: 'flex', gap: 14 }}><Icon name="camera" size={22} color="var(--icon)" /><Icon name="more" size={22} color="var(--icon)" /></div>
      </header>
      <div style={{ flex: 1, overflow: 'hidden', display: 'flex', flexDirection: 'column', gap: 6, padding: '14px 14px' }}>
        <div style={{ textAlign: 'center', fontSize: 12, color: 'var(--text-tertiary)', margin: '0 0 4px' }}>Today 9:24</div>
        <Bubble>hey! did the tokyo shots come out?</Bubble>
        <Bubble me>yeah they're unreal 🔥</Bubble>
        <Bubble me tail>sending the raw files now</Bubble>
        {/* shared post */}
        <div style={{ alignSelf: 'flex-end', maxWidth: '64%', borderRadius: 16, overflow: 'hidden', border: '1px solid var(--border)' }}>
          <img src={PHOTO('photo-1542051841857-5f90071e7989', 400, 300)} alt="" style={{ width: '100%', height: 130, objectFit: 'cover', display: 'block' }} />
          <div style={{ padding: '8px 10px', fontSize: 12 }}><span style={{ fontWeight: 700 }}>devon.shoots</span> · neon nights 🌃</div>
        </div>
        <Bubble tail>saved 🙌 posting tomorrow</Bubble>
        <div style={{ alignSelf: 'flex-start', display: 'flex', gap: 4, background: 'var(--surface-2)', padding: '10px 14px', borderRadius: 20 }}>
          {[0,1,2].map(i => <span key={i} style={{ width: 7, height: 7, borderRadius: '50%', background: 'var(--text-tertiary)' }} />)}
        </div>
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '10px 14px', borderTop: '1px solid var(--divider)', flexShrink: 0 }}>
        <span style={{ width: 38, height: 38, borderRadius: '50%', background: 'var(--gradient-brand)', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}><Icon name="camera" size={20} color="#fff" /></span>
        <div onClick={() => nav.go('stickers')} style={{ cursor: 'pointer', flex: 1, height: 40, borderRadius: 999, background: 'var(--surface-2)', display: 'flex', alignItems: 'center', padding: '0 12px 0 16px', gap: 8 }}>
          <span style={{ flex: 1, color: 'var(--text-tertiary)', fontSize: 14 }}>Message…</span>
          <StickerGlyph size={22} color="var(--icon)" />
        </div>
        <Icon name="like" size={24} color="var(--icon)" />
      </div>
    </Frame>
  );
}

/* E3 · New message (compose) */
function NewMessageScreen() {
  const { Avatar, Icon } = W36;
  const nav = useNav();
  const people = [
    { img: IMG.devon, name: 'devon.shoots', sub: 'Devon Park', online: true },
    { img: IMG.aisha, name: 'aisha.k', sub: 'Aisha Khan' },
    { img: IMG.noor, name: 'noor.films', sub: 'Noor · Following', online: true },
    { img: IMG.liam, name: 'liam', sub: 'Liam Brooks' },
    { img: IMG.sofia, name: 'sofia.eats', sub: 'Sofia Reyes' },
    { img: IMG.kai, name: 'kai', sub: 'Kai Tan' },
  ];
  return (
    <Frame bg="var(--surface)">
      <header style={{ display: 'flex', alignItems: 'center', padding: '0 12px', height: 52, borderBottom: '1px solid var(--divider)', flexShrink: 0 }}>
        <span onClick={nav.back} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="x" size={24} color="var(--text-primary)" /></span>
        <span style={{ fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 17, marginLeft: 8 }}>New message</span>
      </header>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '12px 16px', borderBottom: '1px solid var(--divider)', flexShrink: 0 }}>
        <span style={{ fontSize: 14, fontWeight: 700, color: 'var(--text-secondary)' }}>To:</span>
        <span style={{ fontSize: 14, color: 'var(--text-tertiary)' }}>Search a name or username</span>
      </div>
      <div style={{ padding: '14px 16px 4px', fontSize: 13, fontWeight: 700, color: 'var(--text-secondary)', textTransform: 'uppercase', letterSpacing: '.03em', flexShrink: 0 }}>Suggested</div>
      <div style={{ flex: 1, overflow: 'hidden' }}>
        {people.map((p, i) => (
          <div key={i} onClick={() => nav.go('chat')} style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 12, padding: '9px 16px' }}>
            <Avatar src={p.img} size={48} online={p.online} />
            <div style={{ flex: 1 }}><div style={{ fontSize: 15, fontWeight: 600 }}>{p.name}</div><div style={{ fontSize: 13, color: 'var(--text-secondary)' }}>{p.sub}</div></div>
            <span style={{ width: 24, height: 24, borderRadius: '50%', border: '2px solid var(--border-strong)' }} />
          </div>
        ))}
      </div>
    </Frame>
  );
}

Object.assign(window, { DMListScreen, ChatScreen, NewMessageScreen });

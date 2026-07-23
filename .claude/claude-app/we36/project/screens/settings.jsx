/* We36 — F. Notifications & Settings screens */

/* F1 · Notifications */
function NotificationsScreen() {
  const { Avatar, Button, Icon } = W36;
  const nav = useNav();
  const Item = ({ img, children, thumb, time, follow }) => (
    <div onClick={() => nav.go(follow ? 'otherprofile' : 'postdetail')} style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 12, padding: '10px 16px' }}>
      <Avatar src={img} size={44} />
      <div style={{ flex: 1, fontSize: 14, lineHeight: '19px' }}>{children} <span style={{ color: 'var(--text-tertiary)' }}>{time}</span></div>
      {follow ? <Button variant={follow === 'following' ? 'secondary' : 'primary'} size="sm" style={{ minWidth: 92 }}>{follow === 'following' ? 'Following' : 'Follow'}</Button>
        : thumb && <div style={{ width: 44, height: 44, borderRadius: 8, overflow: 'hidden' }}><img src={PHOTO(thumb, 100, 100)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} /></div>}
    </div>
  );
  const Section = ({ title }) => <div style={{ padding: '14px 16px 6px', fontWeight: 700, fontSize: 14 }}>{title}</div>;
  return (
    <Frame bg="var(--surface)">
      <TopBar title="Activity" back large />
      <div style={{ flex: 1, overflow: 'hidden' }}>
        <Section title="New" />
        <Item img={IMG.devon} time="2m" thumb="photo-1513735492246-483525079686"><b>devon.shoots</b> liked your photo</Item>
        <Item img={IMG.aisha} time="18m" follow="follow"><b>aisha.k</b> started following you</Item>
        <Item img={IMG.noor} time="1h" thumb="photo-1542051841857-5f90071e7989"><b>noor.films</b> commented: "the colors 😍"</Item>
        <Section title="This week" />
        <Item img={IMG.liam} time="2d" follow="following"><b>liam</b> and <b>3 others</b> followed you</Item>
        <Item img={IMG.sofia} time="3d" thumb="photo-1493246507139-91e8fad9978e"><b>sofia.eats</b> mentioned you in a comment</Item>
        <Item img={IMG.kai} time="5d" thumb="photo-1500534314209-a25ddb2bd429"><b>kai</b> saved your post</Item>
      </div>
    </Frame>
  );
}

/* shared settings rows */
function SettingsList({ groups }) {
  const { Icon, Switch } = W36;
  return (
    <div style={{ flex: 1, overflow: 'hidden' }}>
      {groups.map((g, gi) => (
        <div key={gi}>
          <div style={{ padding: '16px 16px 6px', fontSize: 13, fontWeight: 700, color: 'var(--text-secondary)', textTransform: 'uppercase', letterSpacing: '.03em' }}>{g.title}</div>
          {g.rows.map((r, ri) => (
            <div key={ri} onClick={r.onClick} style={{ cursor: r.onClick ? 'pointer' : 'default', display: 'flex', alignItems: 'center', gap: 14, padding: '13px 16px', borderBottom: '1px solid var(--divider)' }}>
              <span style={{ width: 34, height: 34, borderRadius: 9, background: r.tint || 'var(--surface-2)', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}><Icon name={r.icon} size={18} color={r.iconColor || 'var(--icon)'} /></span>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 15, fontWeight: 500 }}>{r.label}</div>
                {r.sub && <div style={{ fontSize: 12, color: 'var(--text-tertiary)' }}>{r.sub}</div>}
              </div>
              {r.toggle !== undefined ? <Switch checked={r.toggle} />
                : r.value ? <span style={{ color: 'var(--text-secondary)', fontSize: 14, display: 'flex', alignItems: 'center', gap: 4 }}>{r.value}<Icon name="chevronLeft" size={18} color="var(--icon)" style={{ transform: 'scaleX(-1)' }} /></span>
                : <Icon name="chevronLeft" size={18} color="var(--icon)" style={{ transform: 'scaleX(-1)' }} />}
            </div>
          ))}
        </div>
      ))}
    </div>
  );
}

/* F2 · Account settings */
function SettingsScreen() {
  const nav = useNav();
  return (
    <Frame bg="var(--surface)">
      <TopBar title="Settings" back large />
      <SettingsList groups={[
        { title: 'Account', rows: [
          { icon: 'profile', label: 'Edit profile', value: '', onClick: () => nav.go('editprofile') },
          { icon: 'notification', label: 'Notifications', value: 'On' },
          { icon: 'message', label: 'Language', value: 'English' },
        ]},
        { title: 'Who can see', rows: [
          { icon: 'settings', label: 'Private account', sub: 'Only approved followers', toggle: true, tint: 'var(--rose-50)', iconColor: 'var(--rose-500)' },
          { icon: 'profile', label: 'Close friends', sub: '24 people', value: '' },
          { icon: 'save', label: 'Activity status', toggle: true },
        ]},
        { title: 'More', rows: [
          { icon: 'settings', label: 'Privacy & security', value: '', onClick: () => nav.go('privacy') },
          { icon: 'x', label: 'Blocked accounts', value: '3', onClick: () => nav.go('report') },
        ]},
      ]} />
    </Frame>
  );
}

/* F3 · Privacy & security */
function PrivacyScreen() {
  return (
    <Frame bg="var(--surface)">
      <TopBar title="Privacy & security" back />
      <SettingsList groups={[
        { title: 'Privacy', rows: [
          { icon: 'settings', label: 'Private account', toggle: true, tint: 'var(--rose-50)', iconColor: 'var(--rose-500)' },
          { icon: 'comment', label: 'Comments', sub: 'People you follow', value: '' },
          { icon: 'message', label: 'Messages', sub: 'Followers only', value: '' },
          { icon: 'profile', label: 'Tags & mentions', value: '' },
        ]},
        { title: 'Security', rows: [
          { icon: 'check', label: 'Two-factor auth', sub: 'Recommended', toggle: true, tint: 'var(--mint-100)', iconColor: 'var(--mint-600)' },
          { icon: 'notification', label: 'Login activity', value: '' },
          { icon: 'save', label: 'Saved login info', toggle: false },
        ]},
        { title: 'Data', rows: [
          { icon: 'more', label: 'Download your data', value: '' },
        ]},
      ]} />
    </Frame>
  );
}

/* F4 · Report / block */
function ReportScreen() {
  const { Avatar, Icon } = W36;
  const nav = useNav();
  const reasons = ['Spam', 'Nudity or sexual content', 'Hate speech or symbols', 'Bullying or harassment', 'False information', 'Scam or fraud', 'Violence', 'Something else'];
  return (
    <Frame bg="var(--surface)">
      <div style={{ display: 'flex', alignItems: 'center', padding: '0 12px', height: 52, borderBottom: '1px solid var(--divider)', flexShrink: 0 }}>
        <span onClick={nav.back} style={{ cursor: 'pointer', display: 'flex' }}><Icon name="x" size={24} color="var(--text-primary)" /></span>
        <span style={{ fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 17, margin: '0 auto', paddingRight: 24 }}>Report</span>
      </div>
      <div style={{ flex: 1, overflow: 'hidden' }}>
        <div style={{ padding: '16px', borderBottom: '8px solid var(--surface-2)' }}>
          <div style={{ fontWeight: 700, fontSize: 17, marginBottom: 4 }}>Why are you reporting this?</div>
          <div style={{ fontSize: 13, color: 'var(--text-secondary)', lineHeight: '19px' }}>Your report is anonymous. If someone is in immediate danger, call local emergency services.</div>
        </div>
        {reasons.map((r, i) => (
          <div key={i} onClick={() => { nav.toast('Thanks — report received'); nav.back(); }} style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', padding: '14px 16px', borderBottom: '1px solid var(--divider)', fontSize: 15 }}>
            {r}<Icon name="chevronLeft" size={18} color="var(--icon)" style={{ marginLeft: 'auto', transform: 'scaleX(-1)' }} />
          </div>
        ))}
        <div onClick={() => { nav.toast('Account blocked'); nav.back(); }} style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 12, padding: '16px' }}>
          <span style={{ width: 36, height: 36, borderRadius: '50%', background: 'var(--error-soft)', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}><Icon name="x" size={18} color="var(--error)" /></span>
          <div style={{ flex: 1 }}><div style={{ fontSize: 15, fontWeight: 600, color: 'var(--error)' }}>Block this account</div><div style={{ fontSize: 12, color: 'var(--text-tertiary)' }}>They won't be able to find your profile or posts</div></div>
        </div>
      </div>
    </Frame>
  );
}

Object.assign(window, { NotificationsScreen, SettingsScreen, PrivacyScreen, ReportScreen });

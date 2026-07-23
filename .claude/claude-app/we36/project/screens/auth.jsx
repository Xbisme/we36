/* We36 — A. Onboarding & Auth screens */

/* A1 · Splash */
function SplashScreen() {
  const { Icon } = W36;
  const nav = useNav();
  return (
    <Frame dark bg="var(--gradient-brand)" lightStatus>
      <div onClick={() => nav.go('onboarding')} style={{ cursor: 'pointer', flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 18 }}>
        <div style={{ width: 84, height: 84, borderRadius: 26, background: 'rgba(255,255,255,.18)', display: 'flex', alignItems: 'center', justifyContent: 'center', backdropFilter: 'blur(4px)' }}>
          <Icon name="camera" size={42} color="#fff" />
        </div>
        <Wordmark size={48} mono />
        <span style={{ color: 'rgba(255,255,255,.85)', fontSize: 15 }}>share your world</span>
      </div>
      <div style={{ paddingBottom: 40, display: 'flex', justifyContent: 'center' }}>
        <div style={{ width: 28, height: 28, border: '3px solid rgba(255,255,255,.35)', borderTopColor: '#fff', borderRadius: '50%' }} />
      </div>
    </Frame>
  );
}

/* A2 · Onboarding intro slides */
function OnboardingScreen() {
  const { Button } = W36;
  const nav = useNav();
  return (
    <Frame>
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', padding: '8px 24px 0' }}>
        <div onClick={() => nav.go('signin')} style={{ cursor: 'pointer', alignSelf: 'flex-end', color: 'var(--text-secondary)', fontSize: 14, fontWeight: 600, padding: 8 }}>Skip</div>
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 28 }}>
          <div style={{ width: 240, height: 300, borderRadius: 24, overflow: 'hidden', boxShadow: 'var(--shadow-lg, 0 20px 40px rgba(26,26,46,.18))', position: 'relative' }}>
            <img src={PHOTO('photo-1529139574466-a303027c1d8b', 480, 600)} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
            <div style={{ position: 'absolute', left: 14, bottom: 14, background: 'rgba(255,255,255,.92)', borderRadius: 999, padding: '6px 12px', display: 'flex', alignItems: 'center', gap: 6, fontSize: 12, fontWeight: 600 }}>📷 reels · stories · feed</div>
          </div>
          <div style={{ textAlign: 'center' }}>
            <h2 style={{ fontFamily: 'var(--font-display)', fontWeight: 800, fontSize: 26, margin: '0 0 8px', letterSpacing: '-0.02em' }}>Capture every moment</h2>
            <p style={{ color: 'var(--text-secondary)', fontSize: 15, lineHeight: '22px', margin: 0 }}>Post photos &amp; reels, drop stories, and keep up with the people you love.</p>
          </div>
          <div style={{ display: 'flex', gap: 8 }}>
            {[0,1,2].map(i => <span key={i} style={{ width: i===0?22:8, height: 8, borderRadius: 999, background: i===0 ? 'var(--gradient-brand)' : 'var(--gray-300)' }} />)}
          </div>
        </div>
      </div>
      <div style={{ padding: '0 24px 28px' }}><Button variant="primary" fullWidth onClick={() => nav.go('signin')}>Get started</Button></div>
    </Frame>
  );
}

/* shared auth wrapper */
function AuthField({ label, placeholder, type, value }) {
  return (
    <label style={{ display: 'block' }}>
      <span style={{ fontSize: 13, fontWeight: 600, color: 'var(--text-secondary)', display: 'block', marginBottom: 6 }}>{label}</span>
      <div style={{ height: 50, borderRadius: 12, border: '1px solid var(--border)', background: 'var(--surface)', display: 'flex', alignItems: 'center', padding: '0 14px', fontSize: 15, color: value ? 'var(--text-primary)' : 'var(--text-tertiary)' }}>
        {value || placeholder}
      </div>
    </label>
  );
}

function OAuthRow() {
  return (
    <div style={{ display: 'flex', gap: 10 }}>
      {['Google','Apple'].map(p => (
        <div key={p} style={{ flex: 1, height: 48, borderRadius: 999, border: '1px solid var(--border)', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8, fontSize: 14, fontWeight: 600 }}>
          <span style={{ fontWeight: 800, color: p==='Google' ? 'var(--rose-500)' : 'var(--ink)' }}>{p==='Google'?'G':''}</span>{p}
        </div>
      ))}
    </div>
  );
}

function OrDivider() {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 12, color: 'var(--text-tertiary)', fontSize: 12 }}>
      <div style={{ flex: 1, height: 1, background: 'var(--border)' }} /> or <div style={{ flex: 1, height: 1, background: 'var(--border)' }} />
    </div>
  );
}

/* A3 · Sign in */
function SignInScreen() {
  const { Button } = W36;
  const nav = useNav();
  return (
    <Frame>
      <div style={{ flex: 1, padding: '24px 24px 0', display: 'flex', flexDirection: 'column' }}>
        <Wordmark size={40} />
        <p style={{ color: 'var(--text-secondary)', fontSize: 15, margin: '8px 0 28px' }}>Welcome back — log in to keep sharing.</p>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
          <AuthField label="Email or phone" value="maya@we36.app" />
          <AuthField label="Password" value="••••••••" type="password" />
          <span onClick={() => nav.go('forgot')} style={{ cursor: 'pointer', alignSelf: 'flex-end', fontSize: 13, fontWeight: 600, color: 'var(--rose-500)' }}>Forgot password?</span>
          <Button variant="primary" fullWidth onClick={() => nav.tab('home')}>Log in</Button>
          <OrDivider />
          <OAuthRow />
        </div>
      </div>
      <div style={{ padding: 20, textAlign: 'center', fontSize: 14, color: 'var(--text-secondary)', borderTop: '1px solid var(--divider)' }}>
        New here? <span onClick={() => nav.go('signup')} style={{ cursor: 'pointer', color: 'var(--rose-500)', fontWeight: 700 }}>Create account</span>
      </div>
    </Frame>
  );
}

/* A4 · Sign up */
function SignUpScreen() {
  const { Button } = W36;
  const nav = useNav();
  return (
    <Frame>
      <div style={{ flex: 1, padding: '24px 24px 0', display: 'flex', flexDirection: 'column' }}>
        <h1 style={{ fontFamily: 'var(--font-display)', fontWeight: 800, fontSize: 28, margin: 0, letterSpacing: '-0.02em' }}>Create your account</h1>
        <p style={{ color: 'var(--text-secondary)', fontSize: 15, margin: '8px 0 24px' }}>Join the community in a minute.</p>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
          <AuthField label="Email" placeholder="you@email.com" />
          <AuthField label="Phone (optional)" placeholder="+1 555 000 0000" />
          <AuthField label="Password" placeholder="At least 8 characters" type="password" />
          <p style={{ fontSize: 12, color: 'var(--text-tertiary)', margin: 0, lineHeight: '18px' }}>By signing up you agree to our Terms and Privacy Policy.</p>
          <Button variant="primary" fullWidth onClick={() => nav.go('setup')}>Sign up</Button>
          <OrDivider />
          <OAuthRow />
        </div>
      </div>
      <div style={{ padding: 20, textAlign: 'center', fontSize: 14, color: 'var(--text-secondary)', borderTop: '1px solid var(--divider)' }}>
        Have an account? <span onClick={() => nav.go('signin')} style={{ cursor: 'pointer', color: 'var(--rose-500)', fontWeight: 700 }}>Log in</span>
      </div>
    </Frame>
  );
}

/* A5 · Forgot password */
function ForgotScreen() {
  const { Button, Icon } = W36;
  return (
    <Frame>
      <TopBar title="" back />
      <div style={{ flex: 1, padding: '8px 24px 0', display: 'flex', flexDirection: 'column' }}>
        <div style={{ width: 64, height: 64, borderRadius: 20, background: 'var(--rose-50)', display: 'flex', alignItems: 'center', justifyContent: 'center', marginBottom: 20 }}>
          <Icon name="notification" size={30} color="var(--rose-500)" />
        </div>
        <h1 style={{ fontFamily: 'var(--font-display)', fontWeight: 800, fontSize: 26, margin: 0 }}>Reset password</h1>
        <p style={{ color: 'var(--text-secondary)', fontSize: 15, margin: '8px 0 24px', lineHeight: '22px' }}>Enter the email linked to your account and we'll send a recovery code.</p>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
          <AuthField label="Email" value="maya@we36.app" />
          <Button variant="primary" fullWidth>Send code</Button>
        </div>
        <div style={{ marginTop: 28, display: 'flex', gap: 10, justifyContent: 'center' }}>
          {[2,7,'',''].map((d,i)=>(
            <div key={i} style={{ width: 52, height: 60, borderRadius: 14, border: `2px solid ${d!==''?'var(--rose-500)':'var(--border)'}`, display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: 'var(--font-display)', fontWeight: 800, fontSize: 24 }}>{d}</div>
          ))}
        </div>
        <p style={{ textAlign: 'center', fontSize: 13, color: 'var(--text-secondary)', marginTop: 16 }}>Resend code in <span style={{ color: 'var(--rose-500)', fontWeight: 700 }}>0:42</span></p>
      </div>
    </Frame>
  );
}

/* A6 · Profile setup */
function ProfileSetupScreen() {
  const { Button, Icon } = W36;
  const nav = useNav();
  return (
    <Frame>
      <TopBar title="Set up profile" back />
      <div style={{ flex: 1, padding: '20px 24px 0', display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
        <div style={{ position: 'relative', marginBottom: 8 }}>
          <div style={{ width: 104, height: 104, borderRadius: '50%', background: 'var(--surface-2)', overflow: 'hidden', border: '3px solid var(--surface)', boxShadow: '0 0 0 2px var(--border)' }}>
            <img src={IMG.maya} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
          </div>
          <span style={{ position: 'absolute', right: -2, bottom: -2, width: 34, height: 34, borderRadius: '50%', background: 'var(--gradient-brand)', display: 'flex', alignItems: 'center', justifyContent: 'center', border: '3px solid var(--surface)' }}>
            <Icon name="camera" size={16} color="#fff" />
          </span>
        </div>
        <p style={{ fontSize: 13, color: 'var(--text-secondary)', margin: '0 0 24px' }}>Add a profile photo</p>
        <div style={{ width: '100%', display: 'flex', flexDirection: 'column', gap: 16 }}>
          <AuthField label="Username" value="@maya.travels" />
          <AuthField label="Display name" value="Maya Oliveira" />
          <div>
            <span style={{ fontSize: 13, fontWeight: 600, color: 'var(--text-secondary)', display: 'block', marginBottom: 6 }}>Bio</span>
            <div style={{ minHeight: 76, borderRadius: 12, border: '1px solid var(--border)', padding: 14, fontSize: 15, color: 'var(--text-primary)', lineHeight: '21px' }}>Chasing light around the world 🌍</div>
          </div>
        </div>
      </div>
      <div style={{ padding: '0 24px 28px' }}><Button variant="primary" fullWidth onClick={() => nav.tab('home')}>Continue</Button></div>
    </Frame>
  );
}

Object.assign(window, { SplashScreen, OnboardingScreen, SignInScreen, SignUpScreen, ForgotScreen, ProfileSetupScreen });

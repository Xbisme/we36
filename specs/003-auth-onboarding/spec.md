# Feature Specification: Auth & Onboarding

**Feature Branch**: `003-auth-onboarding`

**Created**: 2026-06-30

**Status**: Draft

**Input**: User description: "Auth & Onboarding — the authentication gate every other We36 feature sits behind. Builds the pre-auth flow (Splash → Onboarding → Sign in / Sign up / Forgot password → Profile setup) and a session lifecycle, all against the already-implemented backend contract (we36-backend B#002 Auth, base path /v1)."

## Clarifications

### Session 2026-06-30

- Q: On cold start with a valid session, how does the app decide Home vs Profile setup, and what happens offline? → A: Persist `profileCompleted` locally (set at sign-in/setup) so launch routing is instant even offline, then reconcile with the server in the background when next online.
- Q: Where does the onboarding "Get started" action lead (vs "Skip")? → A: "Get started" → Sign up (new users); "Skip" → Sign in (returning users); the two auth screens cross-link.
- Q: On logout and on forced re-login, is locally cached user data wiped? → A: Both logout and forced re-login (irrecoverable session) wipe all user-scoped cached data together with the stored credentials, to prevent leakage to the next account on a shared device.

## User Scenarios & Testing *(mandatory)*

We36 is currently a navigable shell with no way in: the auth-guard skeleton (#001) and the networking/token seams (#002) exist, but no screen lets a person actually authenticate, and no session survives an app restart. This feature is the **gate** — it turns "a guest can see placeholder tabs" into "a real person signs in once, stays signed in, and only then reaches the app." Every later feature depends on a trustworthy answer to *"who is this and are they allowed in?"*.

The journeys below are prioritized so that each can be built, tested, and demonstrated on its own. P1 stories together form the minimum gate (a person can get in and stay in); P2/P3 stories make the gate complete and convenient.

### User Story 1 - Returning user signs in and stays signed in (Priority: P1)

A person who already has an account opens the app, signs in with their email and password, and reaches their home surface. The next time they open the app — even days later, even after the app was force-killed — they land straight inside without signing in again. When they choose to log out, they are returned to the sign-in screen and the app forgets them.

**Why this priority**: This is the spine of the gate. Without persistent, restorable sessions and a working guard, no feature behind authentication is reachable, and a person re-typing their password on every cold start would abandon the app. It is the single most valuable slice.

**Independent Test**: Sign in with valid credentials of a seeded account → land on the home surface; kill and relaunch the app → land on the home surface with no sign-in prompt; trigger logout → return to sign-in; relaunch again → sign-in screen (not home).

**Acceptance Scenarios**:

1. **Given** a registered account and a guest at the Sign in screen, **When** they submit the correct email and password, **Then** they are signed in and routed to the home surface (or to Profile setup if their profile is not yet complete).
2. **Given** a signed-in person who completed profile setup, **When** they fully close and relaunch the app, **Then** the app opens directly to the home surface without asking them to sign in.
3. **Given** a signed-in person, **When** their short-lived access credential expires while they keep using the app, **Then** the app silently restores access in the background and the action they were taking still succeeds, with no visible interruption.
4. **Given** a signed-in person whose session has been invalidated server-side (revoked or expired beyond recovery), **When** the app next needs to act on their behalf, **Then** they are signed out exactly once, returned to Sign in, and shown a clear "your session expired, please sign in again" message — without any redirect loop.
5. **Given** a person submitting wrong credentials, **When** the sign-in fails, **Then** they see a single neutral message that does not reveal whether the email exists, and remain on the Sign in screen with their email preserved.
6. **Given** a person who has failed sign-in too many times, **When** the account is temporarily locked, **Then** they are told to try again after a stated wait, rather than being allowed to keep guessing.
7. **Given** a signed-in person anywhere in the app, **When** they log out, **Then** their stored credentials are erased, they are returned to the pre-auth flow, and a relaunch does not restore the old session.

---

### User Story 2 - New user creates an account and completes a minimal profile (Priority: P1)

A first-time person creates an account with their email and a password, then sets up the minimum profile the social product needs — a unique username and a display name (a short bio is optional) — and arrives at the home surface ready to use the app.

**Why this priority**: A gate with no way to create an account only serves people who already exist. Account creation plus a minimal identity (username) is required before any social feature can address a user, so it is co-critical with sign-in for the MVP.

**Independent Test**: From Sign up, register a new unique email + valid password → land on Profile setup; choose an available username + display name → land on the home surface; relaunch → land on home (profile is remembered as complete).

**Acceptance Scenarios**:

1. **Given** the Sign up screen, **When** a person submits a new, valid email and a password meeting the minimum strength, **Then** an account is created, they are signed in, and they are routed to Profile setup (not yet to home).
2. **Given** the Sign up screen, **When** a person submits an email that already belongs to an account, **Then** they see a clear "this email is already in use" message and can switch to signing in.
3. **Given** the Sign up screen, **When** a person submits an invalid email or a too-short password, **Then** the offending fields are flagged inline before any account is created.
4. **Given** the Profile setup screen, **When** a person types a candidate username, **Then** they get live feedback on whether it is available and whether it meets the format rules (3–30 characters; lowercase letters, digits, dot, underscore; no leading or trailing dot).
5. **Given** a valid available username and a display name, **When** the person confirms, **Then** their profile is marked complete and they are routed to the home surface.
6. **Given** a person who reached Profile setup but closed the app before finishing, **When** they relaunch, **Then** they are returned to Profile setup (still signed in, profile still incomplete) — never stranded on a blank home.
7. **Given** the Profile setup screen in this release, **When** the person views it, **Then** no avatar/photo control is shown (photo upload is deferred to a later media feature), and the screen requires only username + display name with an optional bio.

---

### User Story 3 - Person who forgot their password recovers access (Priority: P2)

A person who cannot remember their password requests a reset by email, receives a 6-digit code, enters the code together with a new password, and can then sign in again.

**Why this priority**: Account recovery prevents permanent lockout and the support burden and churn that follow. It is essential for a real product but not required to prove the gate works for people who remember their credentials, so it sits just below the P1 spine.

**Independent Test**: From Forgot password, submit a registered email → reach the code-entry step; enter the 6-digit code and a new valid password → on success, return to Sign in and sign in with the new password.

**Acceptance Scenarios**:

1. **Given** the Forgot password screen, **When** a person submits an email, **Then** they always advance to the code-entry step with the same neutral confirmation, regardless of whether that email has an account (no account-existence disclosure).
2. **Given** the code-entry step, **When** a person enters the 6-digit code and a new password meeting the minimum strength, **Then** their password is reset, all of that account's existing sessions are invalidated, and they are returned to Sign in.
3. **Given** the code-entry step, **When** the entered code is wrong, expired, or has been attempted too many times, **Then** they see a clear, non-revealing error and can request a fresh code.
4. **Given** a person who just requested a code, **When** they want another, **Then** the "resend" action is unavailable until a short cooldown elapses, with the remaining time shown.

---

### User Story 4 - Person signs in with Google or Apple (Priority: P2)

A person chooses "Continue with Google" or "Continue with Apple" instead of typing a password. The app obtains a provider identity on-device, the backend creates a new account or links to an existing one, and the person continues into the app with the same routing as password sign-in.

**Why this priority**: Social sign-in measurably lifts conversion and is expected by modern users, and offering Apple on iOS is a store requirement once any third-party social login is present. It is high-value but optional relative to the password gate, so P2.

**Independent Test**: Tap "Continue with Google" (and separately "Continue with Apple") → complete the provider step → land on Profile setup (new account) or the home surface (existing, completed account); cancel the provider step → return to the auth screen unchanged with no error noise.

**Acceptance Scenarios**:

1. **Given** the Sign in or Sign up screen, **When** a person completes Google or Apple authentication and it is a new account, **Then** they are signed in and routed to Profile setup.
2. **Given** an existing completed account reachable through the chosen provider, **When** the person authenticates, **Then** they are signed in and routed to the home surface.
3. **Given** the provider sheet is open, **When** the person cancels it, **Then** they are returned to the auth screen with no error message and may try another method.
4. **Given** the provider authentication fails or cannot be verified, **When** the attempt completes, **Then** the person sees a clear "couldn't sign in with that provider" message and can retry or use email instead.
5. **Given** the iOS platform, **When** the auth screens are shown, **Then** "Continue with Apple" is offered alongside "Continue with Google".

---

### User Story 5 - First-time visitor is welcomed once (Priority: P3)

The very first time the app is installed and opened, a short set of intro slides introduces We36 (capturing moments; reels · stories · feed) with the option to Skip or Get started. After this first run, the slides never appear again — subsequent launches go straight to the sign-in (or, if a session exists, into the app).

**Why this priority**: Onboarding slides improve first impression and orientation but deliver no access by themselves; they are the most deferrable slice and must never block a returning user.

**Independent Test**: On a fresh install, launch → see the intro slides; tap Get started → reach Sign up, or tap Skip → reach Sign in; relaunch → no slides, straight to Sign in; (with a session present) relaunch → into the app, no slides.

**Acceptance Scenarios**:

1. **Given** a fresh install with no prior launch, **When** the app opens, **Then** the intro slides are shown with Skip and Get-started actions.
2. **Given** the intro slides, **When** the person taps Get started, **Then** they advance to Sign up and the "already onboarded" state is remembered; **When** instead they tap Skip, **Then** they advance to Sign in and the same state is remembered. (Sign in and Sign up cross-link, so either entry point is recoverable.)
3. **Given** a person who has already seen the slides, **When** they relaunch the app, **Then** the slides are not shown again.
4. **Given** a launch where a valid session already exists, **When** the app opens, **Then** the person goes directly into the app and never sees the slides.

### Edge Cases

- **Offline / no connectivity** during any auth action (sign in, sign up, OAuth exchange, request/verify reset code, profile setup, background refresh): the person sees a clear, retry-able message; nothing crashes; no partial/ambiguous "maybe signed in" state is left behind.
- **Cold-start session restore**: on launch the app decides — valid session → home (or Profile setup if incomplete, using the locally persisted profile-completed flag); no session → pre-auth flow — before showing interactive auth UI, so a signed-in person never momentarily sees the Sign in screen. This decision holds even when the device is offline; the server reconciliation happens later in the background.
- **Silent refresh under concurrency**: if several actions need fresh access at the same moment, only one refresh happens and all actions proceed once it completes (no stampede, no duplicate refreshes).
- **Forced re-login is exactly once**: an irrecoverable session triggers a single sign-out + redirect, never a loop of repeated redirects or repeated error toasts.
- **Duplicate email** on sign up → clear, actionable message routing the person toward Sign in.
- **Locked-out sign-in** (too many failures) → person is told how long to wait, rather than silently failing.
- **Reset code problems** — expired, wrong, or attempted too many times → clear non-revealing error and a path to request a new code (subject to cooldown).
- **Username taken or invalid format** at Profile setup → blocked with specific, immediate feedback; confirmation is disabled until a valid, available username is chosen.
- **OAuth cancelled or failed** → graceful return with no scary errors for a deliberate cancel; a clear message for an actual failure.
- **Profile-setup interrupted** (app killed mid-setup) → next launch returns the still-signed-in person to Profile setup, never to a half-initialized home.
- **Logout while offline** → local session/credentials and all user-scoped cached data are still cleared and the person is returned to the pre-auth flow (server-side revocation, if unreachable, is best-effort and must not block local sign-out).

## Requirements *(mandatory)*

### Functional Requirements

**Account & sign-in**

- **FR-001**: The system MUST let a guest create an account using an email address and a password that meets a minimum length of 8 characters, signing them in on success.
- **FR-002**: The system MUST reject sign up when the email already belongs to an account, with a distinct, user-recognizable "email already in use" outcome separate from generic validation errors.
- **FR-003**: The system MUST validate email format and password minimum length on the client before submission, flagging offending fields inline.
- **FR-004**: The system MUST let a person sign in with their email and password.
- **FR-005**: On failed sign-in, the system MUST present a single neutral message that does not disclose whether the email exists, and MUST preserve the entered email.
- **FR-006**: The system MUST surface a temporary account-lockout state (after repeated failed attempts) as a "try again later" message that communicates a wait, and MUST NOT keep submitting attempts during the lockout.
- **FR-007**: The system MUST treat email as the only login identifier in this release; no phone-based sign in, sign up, or verification is offered, and no phone field is shown.

**Session lifecycle & guard**

- **FR-008**: The system MUST persist the signed-in session across full app restarts using device-secure storage, and MUST restore it on cold start before presenting interactive auth UI.
- **FR-009**: The system MUST route on launch based on session + profile state: no session → pre-auth flow; valid session with completed profile → home surface; valid session with incomplete profile → Profile setup. The profile-completed state MUST be persisted locally (set at sign-in and at profile-setup completion) so that launch routing is immediate and correct even when the device is offline, and MUST be reconciled against the server in the background once connectivity returns.
- **FR-010**: The system MUST silently obtain fresh access in the background when the access credential expires, so that in-flight user actions complete without a visible interruption.
- **FR-011**: The system MUST coordinate concurrent refresh so that at most one refresh is in flight at a time and all waiting actions resume on its completion (single-flight).
- **FR-012**: When the session cannot be recovered (revoked or expired beyond refresh), the system MUST sign the person out exactly once, return them to Sign in, show a clear session-expired message, and wipe all user-scoped cached data along with the stored credentials — with no redirect loop.
- **FR-013**: The system MUST provide a logout action that erases stored credentials, wipes all user-scoped cached data (so nothing leaks to the next account on a shared device), returns the person to the pre-auth flow, and prevents session restoration on subsequent launches; logout MUST complete locally even when offline (any server-side revocation is best-effort and MUST NOT block local sign-out).
- **FR-014**: The system MUST never write credentials (access or refresh tokens, passwords, reset codes) to logs or to any non-secure cache.

**Account recovery**

- **FR-015**: The system MUST let a person request a password reset by email and advance to a code-entry step with a neutral confirmation that does not disclose whether the email has an account.
- **FR-016**: The system MUST accept a 6-digit reset code plus a new password (meeting the minimum length) to reset the password, and MUST communicate that resetting invalidates existing sessions for that account.
- **FR-017**: The system MUST present clear, non-revealing errors for an expired, incorrect, or over-attempted reset code, and offer a path to request a new code.
- **FR-018**: The system MUST gate the "resend code" action behind a visible cooldown timer.

**OAuth**

- **FR-019**: The system MUST offer "Continue with Google" and "Continue with Apple" on the sign-in and sign-up surfaces, obtaining a provider identity on-device and exchanging it for a We36 session.
- **FR-020**: The system MUST apply the same post-authentication routing to OAuth as to password auth (Profile setup when the profile is incomplete, otherwise the home surface).
- **FR-021**: The system MUST treat a user-cancelled provider flow as a silent no-op (return to the auth screen, no error), and a failed/unverifiable provider result as a clear, retry-able error.
- **FR-022**: The system MUST offer Apple sign-in on iOS wherever Google sign-in is offered.

**Profile setup**

- **FR-023**: After first authentication, the system MUST require a person whose profile is incomplete to set a username and a display name before entering the app; a bio is optional.
- **FR-024**: The system MUST validate username format (3–30 characters; lowercase letters, digits, dot, and underscore; no leading or trailing dot) and provide live availability feedback, treating usernames case-insensitively.
- **FR-025**: The system MUST block confirmation of Profile setup until a valid, available username and a display name are provided, and on success MUST mark the profile complete and route to the home surface.
- **FR-026**: The system MUST NOT present an avatar/photo control during Profile setup in this release.
- **FR-027**: The system MUST treat profile completeness as the routing source of truth, so an interrupted setup resumes at Profile setup on the next launch.

**Onboarding & cross-cutting UX**

- **FR-028**: The system MUST show first-launch intro slides only on the first run after install, remember that they were seen, and never show them again; a launch with an existing valid session MUST skip them.
- **FR-029**: The system MUST deliver transient auth feedback (errors, confirmations) via the app's standard transient-message surface, with copy authored English-first and available in Vietnamese.
- **FR-030**: All auth screens MUST be adaptive across phone and tablet/iPad widths and meet the product's accessibility baseline (semantics/labels, text scaling, light and dark themes), consistent with the established design system.
- **FR-031**: The feature MUST be buildable and testable without a live backend by providing in-memory fakes for every new data source it introduces, so the full flow runs offline in tests.

### Key Entities *(include if feature involves data)*

- **Session**: The proof that a person is signed in — a short-lived access credential plus a longer-lived, rotating refresh credential and the access expiry. Held only in secure storage; drives the auth guard. Cleared on logout or irrecoverable expiry.
- **Authenticated User / Profile**: The current person's identity and profile state — stable id, email, optional username and display name (absent until setup), optional bio, and a "profile completed" flag that governs post-auth routing. The profile-completed flag is also cached locally so launch routing works offline. Username is unique (case-insensitive). All user-scoped cached data for this entity is cleared on logout and on forced re-login.
- **Password Reset Request**: A transient recovery attempt tied to an email — a 6-digit code with a limited lifetime and a limited number of attempts, plus a client-side resend cooldown. Not persisted beyond the recovery flow.
- **OAuth Identity**: A link between the person and an external provider (Google or Apple) used to create-or-link an account; the app supplies the provider identity and never stores provider secrets.
- **Onboarding State**: A one-time local flag recording that the first-launch intro has been seen; independent of authentication state.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A new person can go from the Sign up screen to inside the app (account created + minimal profile set) in under 2 minutes without external help.
- **SC-002**: A returning person with a valid session reaches their home surface on cold start in under 2 seconds, with zero password entries and without ever seeing the Sign in screen flash.
- **SC-003**: 100% of expired-access situations during active use are recovered silently — the person completes their action with no visible re-authentication and no error.
- **SC-004**: An irrecoverable session results in exactly one forced sign-out and redirect (never a loop), measured across offline, expired, and revoked cases.
- **SC-005**: A person who forgot their password can regain access (request code → reset → sign in) in under 3 minutes when they receive the code promptly.
- **SC-006**: At least 95% of valid usernames entered at Profile setup receive availability feedback within 1 second of the person pausing typing.
- **SC-007**: Across every auth error path (wrong credentials, lockout, duplicate email, bad/expired code, OAuth cancel/fail, offline), the person always sees an actionable message and the app never crashes or hangs.
- **SC-008**: No credential (token, password, or reset code) appears in application logs in any flow, verified by inspection of logs across the full happy-path and error-path suite.
- **SC-009**: The complete auth flow — sign up, sign in, refresh, recovery, OAuth, profile setup, guard routing — passes its automated test suite against in-memory fakes with no live backend.
- **SC-010**: After logout or a forced re-login, no user-scoped data from the previous account is readable from the local cache — verified by signing out and inspecting that the next session starts with an empty user-scoped store.

## Assumptions

- **Backend contract is fixed and already implemented**: This feature consumes the existing We36 backend "Auth & Identity" capability (base path `/v1`) — email/password register & login, OAuth exchange for Google/Apple, refresh/logout, email-OTP password reset, username availability check, and profile read/setup. The client conforms to that contract; it does not define or change it.
- **Reuse of established infrastructure**: The feature builds on the already-shipped networking core (single API client, centralized error→failure mapping, and the token-storage / refresh / auth-event seams from #002) and the design-system shell, guard skeleton, and shared components from #001 — rather than introducing a parallel networking or token path.
- **Token model**: Access credentials are short-lived (~15 minutes) and refresh credentials are longer-lived and rotating (~30 days, sliding); the client treats exact lifetimes as backend-owned and reacts to expiry signals rather than hard-coding them.
- **OTP delivery is backend-owned**: In non-production the backend may surface the reset code through a development affordance; the client never assumes a specific delivery channel and only handles request → enter-code → reset.
- **OAuth credentials/config** (provider client identifiers, redirect/bundle configuration) are provisioned per environment outside this spec; the feature assumes valid configuration is available for dev and prod builds.
- **Deferred to later specs** (explicitly out of scope here): phone/SMS login and verification; email-verification enforcement; avatar/profile-photo upload; two-factor authentication; account deletion, data export, and the settings surface; public profile viewing; and any feed/profile content.
- **Design alignment deltas** agreed for this release and to be reflected in the UI source of truth: email-only identifier (no phone field on Sign in/Sign up), a 6-box code entry on Forgot password (not 4), and no avatar control on Profile setup.

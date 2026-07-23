/* @ds-bundle: {"format":3,"namespace":"We36DesignSystem_f909ab","components":[{"name":"Button","sourcePath":"components/buttons/Button.jsx"},{"name":"IconButton","sourcePath":"components/buttons/IconButton.jsx"},{"name":"Avatar","sourcePath":"components/display/Avatar.jsx"},{"name":"Badge","sourcePath":"components/display/Badge.jsx"},{"name":"PostCard","sourcePath":"components/display/PostCard.jsx"},{"name":"Tag","sourcePath":"components/display/Tag.jsx"},{"name":"Input","sourcePath":"components/forms/Input.jsx"},{"name":"SearchBar","sourcePath":"components/forms/SearchBar.jsx"},{"name":"Switch","sourcePath":"components/forms/Switch.jsx"},{"name":"Icon","sourcePath":"components/icons/Icon.jsx"},{"name":"ICON_NAMES","sourcePath":"components/icons/Icon.jsx"},{"name":"BottomNav","sourcePath":"components/navigation/BottomNav.jsx"}],"sourceHashes":{"components/buttons/Button.jsx":"178d2c529f42","components/buttons/IconButton.jsx":"0ddf0ba6cd76","components/display/Avatar.jsx":"4d2a034b0289","components/display/Badge.jsx":"f3ebdca2156a","components/display/PostCard.jsx":"ac35beb14cff","components/display/Tag.jsx":"59b7632d9df1","components/forms/Input.jsx":"06ecd81e393e","components/forms/SearchBar.jsx":"0e466e2a4524","components/forms/Switch.jsx":"ae9529270788","components/icons/Icon.jsx":"fe076353bd3d","components/navigation/BottomNav.jsx":"18c1e4157787","ui_kits/we36-app/ExploreScreen.jsx":"b03b620a19de","ui_kits/we36-app/FeedScreen.jsx":"773e589f9197","ui_kits/we36-app/ProfileScreen.jsx":"79ff6eb5c314","ui_kits/we36-app/ReelsScreen.jsx":"e375731842cf"},"inlinedExternals":[],"unexposedExports":[]} */

(() => {

const __ds_ns = (window.We36DesignSystem_f909ab = window.We36DesignSystem_f909ab || {});

const __ds_scope = {};

(__ds_ns.__errors = __ds_ns.__errors || []);

// components/display/Avatar.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
const SIZES = {
  xs: 24,
  sm: 32,
  md: 44,
  lg: 56,
  xl: 88
};

/**
 * We36 Avatar — circular user image with optional gradient story ring and
 * presence/notification dot. `seen` desaturates the ring (story already viewed).
 */
function Avatar({
  src,
  alt = '',
  size = 'md',
  ring = false,
  seen = false,
  online = false,
  initials,
  style = {},
  ...rest
}) {
  const px = typeof size === 'number' ? size : SIZES[size] || SIZES.md;
  const ringGap = px >= 56 ? 3 : 2;
  const ringWidth = px >= 56 ? 3 : 2;
  const total = px + (ring ? (ringGap + ringWidth) * 2 : 0);
  const img = /*#__PURE__*/React.createElement("div", {
    style: {
      width: px,
      height: px,
      borderRadius: '50%',
      overflow: 'hidden',
      background: src ? 'var(--surface-2)' : 'var(--gradient-brand-soft)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      color: 'var(--white)',
      fontFamily: 'var(--font-display)',
      fontWeight: 'var(--fw-bold)',
      fontSize: px * 0.38,
      flexShrink: 0
    }
  }, src ? /*#__PURE__*/React.createElement("img", {
    src: src,
    alt: alt,
    style: {
      width: '100%',
      height: '100%',
      objectFit: 'cover',
      display: 'block'
    }
  }) : initials || '');
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      position: 'relative',
      width: total,
      height: total,
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      ...style
    }
  }, rest), ring ? /*#__PURE__*/React.createElement("div", {
    style: {
      width: total,
      height: total,
      borderRadius: '50%',
      padding: ringWidth,
      background: seen ? 'var(--border-strong)' : 'var(--gradient-story)',
      boxSizing: 'border-box'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: '100%',
      height: '100%',
      borderRadius: '50%',
      padding: ringGap,
      background: 'var(--surface)',
      boxSizing: 'border-box'
    }
  }, img)) : img, online && /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      right: ring ? ringWidth : 0,
      bottom: ring ? ringWidth : 0,
      width: Math.max(10, px * 0.28),
      height: Math.max(10, px * 0.28),
      borderRadius: '50%',
      background: 'var(--mint-400)',
      border: '2px solid var(--surface)'
    }
  }));
}
Object.assign(__ds_scope, { Avatar });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/display/Avatar.jsx", error: String((e && e.message) || e) }); }

// components/display/Badge.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
const TONES = {
  rose: {
    bg: 'var(--rose-500)',
    fg: 'var(--white)'
  },
  violet: {
    bg: 'var(--violet-500)',
    fg: 'var(--white)'
  },
  amber: {
    bg: 'var(--amber-400)',
    fg: 'var(--ink)'
  },
  mint: {
    bg: 'var(--mint-400)',
    fg: 'var(--ink)'
  },
  neutral: {
    bg: 'var(--surface-2)',
    fg: 'var(--text-secondary)'
  },
  gradient: {
    bg: 'var(--gradient-brand)',
    fg: 'var(--white)'
  }
};

/**
 * We36 Badge — count pill, status label, or bare notification dot.
 */
function Badge({
  children,
  tone = 'rose',
  dot = false,
  style = {},
  ...rest
}) {
  const t = TONES[tone] || TONES.rose;
  if (dot) {
    return /*#__PURE__*/React.createElement("span", _extends({
      style: {
        display: 'inline-block',
        width: 10,
        height: 10,
        borderRadius: '50%',
        background: t.bg,
        border: '2px solid var(--surface)',
        boxSizing: 'content-box',
        ...style
      }
    }, rest));
  }
  return /*#__PURE__*/React.createElement("span", _extends({
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      minWidth: 20,
      height: 20,
      padding: '0 7px',
      fontFamily: 'var(--font-body)',
      fontSize: 12,
      fontWeight: 'var(--fw-bold)',
      lineHeight: 1,
      color: t.fg,
      background: t.bg,
      borderRadius: 'var(--radius-full)',
      ...style
    }
  }, rest), children);
}
Object.assign(__ds_scope, { Badge });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/display/Badge.jsx", error: String((e && e.message) || e) }); }

// components/display/Tag.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * We36 Tag / Chip — hashtags, topics, filters. `active` fills with soft accent;
 * `removable` shows an × ; clickable when onClick provided.
 */
function Tag({
  children,
  active = false,
  onClick,
  hashtag = false,
  style = {},
  ...rest
}) {
  const [hover, setHover] = React.useState(false);
  const clickable = !!onClick;
  return /*#__PURE__*/React.createElement("span", _extends({
    onClick: onClick,
    onMouseEnter: () => setHover(true),
    onMouseLeave: () => setHover(false),
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: 4,
      height: 32,
      padding: '0 14px',
      fontFamily: 'var(--font-body)',
      fontSize: 14,
      fontWeight: 'var(--fw-semibold)',
      lineHeight: 1,
      borderRadius: 'var(--radius-full)',
      cursor: clickable ? 'pointer' : 'default',
      color: active ? 'var(--accent)' : 'var(--text-secondary)',
      background: active ? 'var(--accent-soft)' : hover && clickable ? 'var(--surface-2)' : 'var(--surface-2)',
      border: active ? '1px solid var(--accent)' : '1px solid transparent',
      transition: 'all var(--dur-base) var(--ease-standard)',
      ...style
    }
  }, rest), hashtag && /*#__PURE__*/React.createElement("span", {
    style: {
      color: active ? 'var(--accent)' : 'var(--text-tertiary)',
      fontWeight: 'var(--fw-bold)'
    }
  }, "#"), children);
}
Object.assign(__ds_scope, { Tag });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/display/Tag.jsx", error: String((e && e.message) || e) }); }

// components/forms/Input.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * We36 text input with label, helper/error text and optional adornments.
 */
function Input({
  label,
  placeholder,
  value,
  onChange,
  type = 'text',
  helperText,
  error = false,
  disabled = false,
  fullWidth = true,
  style = {},
  ...rest
}) {
  const [focus, setFocus] = React.useState(false);
  const borderColor = error ? 'var(--error)' : focus ? 'var(--accent)' : 'var(--border-strong)';
  return /*#__PURE__*/React.createElement("div", {
    style: {
      width: fullWidth ? '100%' : undefined,
      fontFamily: 'var(--font-body)',
      ...style
    }
  }, label && /*#__PURE__*/React.createElement("label", {
    style: {
      display: 'block',
      fontSize: 'var(--text-label-size)',
      fontWeight: 'var(--fw-semibold)',
      color: 'var(--text-primary)',
      marginBottom: 'var(--space-2)'
    }
  }, label), /*#__PURE__*/React.createElement("input", _extends({
    type: type,
    placeholder: placeholder,
    value: value,
    onChange: onChange,
    disabled: disabled,
    onFocus: () => setFocus(true),
    onBlur: () => setFocus(false),
    style: {
      width: '100%',
      height: 48,
      padding: '0 16px',
      fontFamily: 'var(--font-body)',
      fontSize: 'var(--text-body-size)',
      color: 'var(--text-primary)',
      background: disabled ? 'var(--surface-2)' : 'var(--surface)',
      border: `1.5px solid ${borderColor}`,
      borderRadius: 'var(--radius-md)',
      outline: 'none',
      boxShadow: focus && !error ? '0 0 0 4px var(--accent-soft)' : 'none',
      opacity: disabled ? 0.6 : 1,
      transition: 'border-color var(--dur-base) var(--ease-standard), box-shadow var(--dur-base) var(--ease-standard)',
      boxSizing: 'border-box'
    }
  }, rest)), helperText && /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 'var(--text-caption-size)',
      lineHeight: 'var(--text-caption-lh)',
      color: error ? 'var(--error)' : 'var(--text-secondary)',
      marginTop: 'var(--space-2)'
    }
  }, helperText));
}
Object.assign(__ds_scope, { Input });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/forms/Input.jsx", error: String((e && e.message) || e) }); }

// components/forms/Switch.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * We36 toggle switch — gradient track when on, springy knob.
 */
function Switch({
  checked = false,
  onChange,
  disabled = false,
  style = {},
  ...rest
}) {
  return /*#__PURE__*/React.createElement("button", _extends({
    type: "button",
    role: "switch",
    "aria-checked": checked,
    disabled: disabled,
    onClick: disabled ? undefined : () => onChange && onChange(!checked),
    style: {
      position: 'relative',
      width: 48,
      height: 28,
      flexShrink: 0,
      borderRadius: 'var(--radius-full)',
      border: 'none',
      cursor: disabled ? 'not-allowed' : 'pointer',
      background: checked ? 'var(--gradient-brand)' : 'var(--gray-300)',
      opacity: disabled ? 0.5 : 1,
      transition: 'background var(--dur-base) var(--ease-standard)',
      padding: 0,
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      top: 3,
      left: checked ? 23 : 3,
      width: 22,
      height: 22,
      borderRadius: '50%',
      background: 'var(--white)',
      boxShadow: 'var(--shadow-sm)',
      transition: 'left var(--dur-base) var(--ease-spring)'
    }
  }));
}
Object.assign(__ds_scope, { Switch });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/forms/Switch.jsx", error: String((e && e.message) || e) }); }

// components/icons/Icon.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * We36 icon set — Lucide geometry (ISC licensed), unified at 24×24,
 * stroke-width 2, round caps/joins. Outline by default; `solid` swaps
 * to a filled variant for active states (heart, bookmark, home).
 */

const PATHS = {
  home: ['M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z', 'M9 22V12h6v10'],
  search: ['M11 19a8 8 0 1 0 0-16 8 8 0 0 0 0 16z', 'm21 21-4.3-4.3'],
  reels: ['M3 11h18v8a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z', 'M20.2 6 3 11l-.9-2.4c-.3-1.1.3-2.2 1.3-2.5l13.5-4c1.1-.3 2.2.3 2.5 1.3z', 'm6.2 5.3 3.1 3.9', 'm12.4 3.4 3.1 4'],
  message: ['M7.9 20A9 9 0 1 0 4 16.1L2 22z'],
  profile: ['M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2', 'M12 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8z'],
  like: ['M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7z'],
  comment: ['M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z'],
  share: ['M22 2 11 13', 'M22 2 15 22l-4-9-9-4z'],
  save: ['m19 21-7-4-7 4V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z'],
  notification: ['M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9', 'M10.3 21a1.94 1.94 0 0 0 3.4 0'],
  plus: ['M5 12h14', 'M12 5v14'],
  more: ['M12 13a1 1 0 1 0 0-2 1 1 0 0 0 0 2z', 'M19 13a1 1 0 1 0 0-2 1 1 0 0 0 0 2z', 'M5 13a1 1 0 1 0 0-2 1 1 0 0 0 0 2z'],
  settings: ['M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.08a2 2 0 0 1-1-1.74v-.5a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z', 'M12 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6z'],
  check: ['M20 6 9 17l-5-5'],
  x: ['M18 6 6 18', 'M6 6l12 12'],
  camera: ['M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3z', 'M12 17a4 4 0 1 0 0-8 4 4 0 0 0 0 8z'],
  chevronLeft: ['m15 18-6-6 6-6']
};

// Solid variants for filled active states
const SOLID = {
  home: {
    paths: ['M11.2 3.3 3.7 9.1A2 2 0 0 0 3 10.6V19a2 2 0 0 0 2 2h3v-7a1 1 0 0 1 1-1h6a1 1 0 0 1 1 1v7h3a2 2 0 0 0 2-2v-8.4a2 2 0 0 0-.7-1.5l-7.5-5.8a2 2 0 0 0-2.4 0z']
  },
  like: {
    paths: PATHS.like
  },
  save: {
    paths: PATHS.save
  },
  reels: {
    paths: ['M3 11h18v8a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z', 'M20.2 6 3 11l-.9-2.4c-.3-1.1.3-2.2 1.3-2.5l13.5-4c1.1-.3 2.2.3 2.5 1.3z']
  }
};
function Icon({
  name,
  size = 24,
  color = 'currentColor',
  strokeWidth = 2,
  solid = false,
  style = {},
  ...rest
}) {
  const def = solid && SOLID[name] ? SOLID[name] : null;
  const paths = def ? def.paths : PATHS[name] || [];
  const fill = solid ? color : 'none';
  return /*#__PURE__*/React.createElement("svg", _extends({
    width: size,
    height: size,
    viewBox: "0 0 24 24",
    fill: fill,
    stroke: color,
    strokeWidth: solid ? 0 : strokeWidth,
    strokeLinecap: "round",
    strokeLinejoin: "round",
    style: {
      display: 'block',
      flexShrink: 0,
      ...style
    },
    "aria-hidden": "true"
  }, rest), paths.map((d, i) => /*#__PURE__*/React.createElement("path", {
    key: i,
    d: d
  })));
}
const ICON_NAMES = Object.keys(PATHS);
Object.assign(__ds_scope, { Icon, ICON_NAMES });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/icons/Icon.jsx", error: String((e && e.message) || e) }); }

// components/buttons/Button.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
const SIZES = {
  sm: {
    height: 36,
    padding: '0 14px',
    font: 14,
    gap: 6,
    icon: 16
  },
  md: {
    height: 44,
    padding: '0 20px',
    font: 15,
    gap: 8,
    icon: 18
  },
  lg: {
    height: 52,
    padding: '0 28px',
    font: 16,
    gap: 8,
    icon: 20
  }
};

/**
 * We36 Button — primary (gradient), secondary (outline), ghost.
 */
function Button({
  children,
  variant = 'primary',
  size = 'md',
  disabled = false,
  fullWidth = false,
  iconLeft,
  iconRight,
  onClick,
  style = {},
  ...rest
}) {
  const s = SIZES[size] || SIZES.md;
  const [hover, setHover] = React.useState(false);
  const [press, setPress] = React.useState(false);
  const base = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: s.gap,
    height: s.height,
    minWidth: s.height,
    padding: s.padding,
    width: fullWidth ? '100%' : undefined,
    fontFamily: 'var(--font-body)',
    fontSize: s.font,
    fontWeight: 'var(--fw-semibold)',
    lineHeight: 1,
    borderRadius: 'var(--radius-full)',
    border: '1px solid transparent',
    cursor: disabled ? 'not-allowed' : 'pointer',
    opacity: disabled ? 0.45 : 1,
    transition: 'transform var(--dur-fast) var(--ease-standard), background var(--dur-base) var(--ease-standard), box-shadow var(--dur-base) var(--ease-standard)',
    transform: press && !disabled ? 'scale(0.97)' : 'scale(1)',
    whiteSpace: 'nowrap',
    userSelect: 'none'
  };
  const variants = {
    primary: {
      color: 'var(--text-on-brand)',
      background: hover && !disabled ? 'var(--gradient-brand-soft)' : 'var(--gradient-brand)',
      boxShadow: disabled ? 'none' : hover ? 'var(--shadow-brand)' : 'var(--shadow-sm)'
    },
    secondary: {
      color: 'var(--text-primary)',
      background: hover && !disabled ? 'var(--surface-2)' : 'var(--surface)',
      borderColor: 'var(--border-strong)'
    },
    ghost: {
      color: 'var(--accent)',
      background: hover && !disabled ? 'var(--accent-soft)' : 'transparent'
    }
  };
  return /*#__PURE__*/React.createElement("button", _extends({
    type: "button",
    disabled: disabled,
    onClick: disabled ? undefined : onClick,
    onMouseEnter: () => setHover(true),
    onMouseLeave: () => {
      setHover(false);
      setPress(false);
    },
    onMouseDown: () => setPress(true),
    onMouseUp: () => setPress(false),
    style: {
      ...base,
      ...variants[variant],
      ...style
    }
  }, rest), iconLeft && /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: iconLeft,
    size: s.icon
  }), children, iconRight && /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: iconRight,
    size: s.icon
  }));
}
Object.assign(__ds_scope, { Button });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/buttons/Button.jsx", error: String((e && e.message) || e) }); }

// components/buttons/IconButton.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
const SIZES = {
  sm: {
    box: 36,
    icon: 18
  },
  md: {
    box: 44,
    icon: 22
  },
  lg: {
    box: 52,
    icon: 26
  }
};

/**
 * We36 IconButton — square/circular tappable icon. For feed actions, nav,
 * toolbars. `active` turns it accent-colored with a solid glyph.
 */
function IconButton({
  name,
  size = 'md',
  variant = 'ghost',
  active = false,
  disabled = false,
  label,
  onClick,
  style = {},
  ...rest
}) {
  const s = SIZES[size] || SIZES.md;
  const [hover, setHover] = React.useState(false);
  const [press, setPress] = React.useState(false);
  const variants = {
    ghost: {
      background: hover && !disabled ? 'var(--surface-2)' : 'transparent',
      color: active ? 'var(--icon-active)' : 'var(--icon)'
    },
    filled: {
      background: active ? 'var(--accent)' : hover && !disabled ? 'var(--surface-2)' : 'var(--surface)',
      color: active ? 'var(--text-on-brand)' : 'var(--text-primary)',
      border: '1px solid var(--border)'
    }
  };
  return /*#__PURE__*/React.createElement("button", _extends({
    type: "button",
    "aria-label": label,
    disabled: disabled,
    onClick: disabled ? undefined : onClick,
    onMouseEnter: () => setHover(true),
    onMouseLeave: () => {
      setHover(false);
      setPress(false);
    },
    onMouseDown: () => setPress(true),
    onMouseUp: () => setPress(false),
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      width: s.box,
      height: s.box,
      borderRadius: 'var(--radius-full)',
      border: 'none',
      cursor: disabled ? 'not-allowed' : 'pointer',
      opacity: disabled ? 0.4 : 1,
      transition: 'transform var(--dur-fast) var(--ease-spring), background var(--dur-base) var(--ease-standard), color var(--dur-base) var(--ease-standard)',
      transform: press && !disabled ? 'scale(0.88)' : 'scale(1)',
      ...variants[variant],
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: name,
    size: s.icon,
    solid: active
  }));
}
Object.assign(__ds_scope, { IconButton });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/buttons/IconButton.jsx", error: String((e && e.message) || e) }); }

// components/display/PostCard.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * We36 PostCard — the core feed unit. User header, media, like/comment/share +
 * save actions, like count and caption. Self-contained interactive state for
 * like and save toggles.
 */
function PostCard({
  user = 'jordan',
  avatar,
  location,
  image,
  likes = 0,
  caption,
  comments,
  time = '2h',
  style = {},
  ...rest
}) {
  const [liked, setLiked] = React.useState(false);
  const [saved, setSaved] = React.useState(false);
  const total = likes + (liked ? 1 : 0);
  return /*#__PURE__*/React.createElement("article", _extends({
    style: {
      width: '100%',
      maxWidth: 'var(--feed-max)',
      background: 'var(--surface)',
      border: '1px solid var(--border)',
      borderRadius: 'var(--radius-lg)',
      overflow: 'hidden',
      boxShadow: 'var(--shadow-sm)',
      fontFamily: 'var(--font-body)',
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("header", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 'var(--space-3)',
      padding: 'var(--space-3) var(--space-4)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.Avatar, {
    src: avatar,
    size: "md",
    ring: true,
    initials: user.slice(0, 1).toUpperCase()
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      minWidth: 0
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 14,
      fontWeight: 'var(--fw-semibold)',
      color: 'var(--text-primary)'
    }
  }, user), location && /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 12,
      color: 'var(--text-secondary)'
    }
  }, location)), /*#__PURE__*/React.createElement(__ds_scope.IconButton, {
    name: "more",
    size: "sm",
    label: "More options"
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      width: '100%',
      aspectRatio: '4 / 5',
      background: image ? 'var(--surface-2)' : 'var(--gradient-brand-soft)'
    }
  }, image && /*#__PURE__*/React.createElement("img", {
    src: image,
    alt: "",
    style: {
      width: '100%',
      height: '100%',
      objectFit: 'cover',
      display: 'block'
    }
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      padding: 'var(--space-2) var(--space-3)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 'var(--space-1)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.IconButton, {
    name: "like",
    active: liked,
    onClick: () => setLiked(v => !v),
    label: "Like"
  }), /*#__PURE__*/React.createElement(__ds_scope.IconButton, {
    name: "comment",
    label: "Comment"
  }), /*#__PURE__*/React.createElement(__ds_scope.IconButton, {
    name: "share",
    label: "Share"
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      marginLeft: 'auto'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.IconButton, {
    name: "save",
    active: saved,
    onClick: () => setSaved(v => !v),
    label: "Save"
  }))), /*#__PURE__*/React.createElement("div", {
    style: {
      padding: '0 var(--space-4) var(--space-4)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 14,
      fontWeight: 'var(--fw-bold)',
      color: 'var(--text-primary)'
    }
  }, total.toLocaleString(), " likes"), caption && /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 14,
      lineHeight: '20px',
      color: 'var(--text-primary)',
      marginTop: 4
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontWeight: 'var(--fw-semibold)'
    }
  }, user), " ", caption), comments != null && comments > 0 && /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 13,
      color: 'var(--text-secondary)',
      marginTop: 6,
      cursor: 'pointer'
    }
  }, "View all ", comments, " comments"), /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 11,
      color: 'var(--text-tertiary)',
      marginTop: 6,
      textTransform: 'uppercase',
      letterSpacing: 'var(--tracking-wide)'
    }
  }, time)));
}
Object.assign(__ds_scope, { PostCard });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/display/PostCard.jsx", error: String((e && e.message) || e) }); }

// components/forms/SearchBar.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * We36 search bar — pill, soft surface, leading search glyph. Used in the
 * search tab and discovery surfaces.
 */
function SearchBar({
  placeholder = 'Search We36',
  value,
  onChange,
  disabled = false,
  style = {},
  ...rest
}) {
  const [focus, setFocus] = React.useState(false);
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 'var(--space-2)',
      height: 44,
      padding: '0 16px',
      background: 'var(--surface-2)',
      border: `1.5px solid ${focus ? 'var(--accent)' : 'transparent'}`,
      borderRadius: 'var(--radius-full)',
      boxShadow: focus ? '0 0 0 4px var(--accent-soft)' : 'none',
      transition: 'border-color var(--dur-base) var(--ease-standard), box-shadow var(--dur-base) var(--ease-standard)',
      opacity: disabled ? 0.6 : 1,
      ...style
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: "search",
    size: 18,
    color: "var(--text-tertiary)"
  }), /*#__PURE__*/React.createElement("input", _extends({
    type: "text",
    placeholder: placeholder,
    value: value,
    onChange: onChange,
    disabled: disabled,
    onFocus: () => setFocus(true),
    onBlur: () => setFocus(false),
    style: {
      flex: 1,
      border: 'none',
      background: 'transparent',
      outline: 'none',
      fontFamily: 'var(--font-body)',
      fontSize: 'var(--text-body-size)',
      color: 'var(--text-primary)'
    }
  }, rest)));
}
Object.assign(__ds_scope, { SearchBar });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/forms/SearchBar.jsx", error: String((e && e.message) || e) }); }

// components/navigation/BottomNav.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
const ITEMS = [{
  key: 'home',
  icon: 'home',
  label: 'Home'
}, {
  key: 'search',
  icon: 'search',
  label: 'Search'
}, {
  key: 'reels',
  icon: 'reels',
  label: 'Reels'
}, {
  key: 'message',
  icon: 'message',
  label: 'Messages'
}, {
  key: 'profile',
  icon: 'profile',
  label: 'Profile'
}];

/**
 * We36 BottomNav / tab bar. Five destinations, active item rendered in accent
 * with a solid glyph. The center action can be elevated as a gradient FAB-style
 * "create" button via `create`.
 */
function BottomNav({
  active = 'home',
  onChange,
  items = ITEMS,
  badges = {},
  style = {},
  ...rest
}) {
  return /*#__PURE__*/React.createElement("nav", _extends({
    style: {
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-around',
      width: '100%',
      height: 64,
      padding: '0 var(--space-2)',
      background: 'var(--surface)',
      borderTop: '1px solid var(--border)',
      boxSizing: 'border-box',
      ...style
    }
  }, rest), items.map(item => {
    const isActive = item.key === active;
    return /*#__PURE__*/React.createElement("button", {
      key: item.key,
      type: "button",
      "aria-label": item.label,
      onClick: () => onChange && onChange(item.key),
      style: {
        position: 'relative',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        gap: 2,
        flex: 1,
        height: '100%',
        minWidth: 'var(--tap-target-min)',
        border: 'none',
        background: 'transparent',
        cursor: 'pointer',
        color: isActive ? 'var(--icon-active)' : 'var(--icon)',
        transition: 'color var(--dur-base) var(--ease-standard)'
      }
    }, /*#__PURE__*/React.createElement("span", {
      style: {
        position: 'relative'
      }
    }, /*#__PURE__*/React.createElement(__ds_scope.Icon, {
      name: item.icon,
      size: 26,
      solid: isActive
    }), badges[item.key] && /*#__PURE__*/React.createElement("span", {
      style: {
        position: 'absolute',
        top: -4,
        right: -6,
        minWidth: 16,
        height: 16,
        padding: '0 4px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontSize: 10,
        fontWeight: 'var(--fw-bold)',
        color: 'var(--white)',
        background: 'var(--rose-500)',
        borderRadius: 'var(--radius-full)',
        border: '2px solid var(--surface)',
        fontFamily: 'var(--font-body)'
      }
    }, badges[item.key])));
  }));
}
Object.assign(__ds_scope, { BottomNav });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/navigation/BottomNav.jsx", error: String((e && e.message) || e) }); }

// ui_kits/we36-app/ExploreScreen.jsx
try { (() => {
/* We36 app — Explore / Search screen. Search bar, hashtag chips, photo grid. */
const EXPLORE_TAGS = [{
  label: 'For you',
  active: true
}, {
  label: 'travel',
  hashtag: true
}, {
  label: 'food',
  hashtag: true
}, {
  label: 'design',
  hashtag: true
}, {
  label: 'fitness',
  hashtag: true
}];
const EXPLORE_GRID = ['photo-1504674900247-0877df9cc836', 'photo-1519681393784-d120267933ba', 'photo-1493246507139-91e8fad9978e', 'photo-1502780402662-acc01917738e', 'photo-1469474968028-56623f02e42e', 'photo-1500534314209-a25ddb2bd429', 'photo-1441974231531-c6227db76b6e', 'photo-1470770841072-f978cf4d019e', 'photo-1426604966848-d7adac402bff'];
function ExploreScreen() {
  const {
    SearchBar,
    Tag
  } = window.We36DesignSystem_f909ab;
  return /*#__PURE__*/React.createElement("div", {
    style: {
      background: 'var(--bg-app)',
      minHeight: '100%'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      padding: '12px 16px',
      background: 'var(--surface)',
      borderBottom: '1px solid var(--divider)',
      position: 'sticky',
      top: 0,
      zIndex: 2
    }
  }, /*#__PURE__*/React.createElement(SearchBar, {
    placeholder: "Search people, tags, places"
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 8,
      marginTop: 12,
      overflowX: 'auto'
    }
  }, EXPLORE_TAGS.map((t, i) => /*#__PURE__*/React.createElement(Tag, {
    key: i,
    active: t.active,
    hashtag: t.hashtag,
    style: {
      flexShrink: 0
    }
  }, t.label)))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gridTemplateColumns: '1fr 1fr 1fr',
      gap: 2,
      padding: 2
    }
  }, EXPLORE_GRID.map((id, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      aspectRatio: '1',
      background: 'var(--surface-2)',
      overflow: 'hidden'
    }
  }, /*#__PURE__*/React.createElement("img", {
    src: `https://images.unsplash.com/${id}?w=300&h=300&fit=crop`,
    alt: "",
    style: {
      width: '100%',
      height: '100%',
      objectFit: 'cover',
      display: 'block'
    }
  })))));
}
window.ExploreScreen = ExploreScreen;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/we36-app/ExploreScreen.jsx", error: String((e && e.message) || e) }); }

// ui_kits/we36-app/FeedScreen.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/* We36 app — Feed (home) screen. Stories rail + post feed. */
const FEED_STORIES = [{
  user: 'Your story',
  me: true,
  img: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=160&h=160&fit=crop'
}, {
  user: 'maya',
  img: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=160&h=160&fit=crop'
}, {
  user: 'devon',
  img: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=160&h=160&fit=crop'
}, {
  user: 'aisha',
  seen: true,
  img: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=160&h=160&fit=crop'
}, {
  user: 'liam',
  img: 'https://images.unsplash.com/photo-1463453091185-61582044d556?w=160&h=160&fit=crop'
}, {
  user: 'noor',
  seen: true,
  img: 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=160&h=160&fit=crop'
}];
const FEED_POSTS = [{
  user: 'maya.travels',
  avatar: FEED_STORIES[1].img,
  location: 'Lisbon, Portugal',
  image: 'https://images.unsplash.com/photo-1513735492246-483525079686?w=900&h=1100&fit=crop',
  likes: 1240,
  caption: 'golden hour never misses ☀️ #goldenhour',
  comments: 86,
  time: '2h'
}, {
  user: 'devon.shoots',
  avatar: FEED_STORIES[2].img,
  location: 'Tokyo',
  image: 'https://images.unsplash.com/photo-1542051841857-5f90071e7989?w=900&h=1100&fit=crop',
  likes: 873,
  caption: 'neon nights in Shibuya',
  comments: 41,
  time: '5h'
}];
function StoriesRail() {
  const {
    Avatar,
    Icon
  } = window.We36DesignSystem_f909ab;
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 14,
      padding: '12px 16px',
      overflowX: 'auto',
      background: 'var(--surface)',
      borderBottom: '1px solid var(--divider)'
    }
  }, FEED_STORIES.map((s, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      gap: 6,
      flexShrink: 0,
      width: 64
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative'
    }
  }, /*#__PURE__*/React.createElement(Avatar, {
    src: s.img,
    size: 56,
    ring: !s.me,
    seen: s.seen
  }), s.me && /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      right: -2,
      bottom: -2,
      width: 22,
      height: 22,
      borderRadius: '50%',
      background: 'var(--gradient-brand)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      border: '2px solid var(--surface)'
    }
  }, /*#__PURE__*/React.createElement(Icon, {
    name: "plus",
    size: 13,
    color: "#fff"
  }))), /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 11,
      color: 'var(--text-secondary)',
      maxWidth: 64,
      overflow: 'hidden',
      textOverflow: 'ellipsis',
      whiteSpace: 'nowrap',
      fontFamily: 'var(--font-body)'
    }
  }, s.user))));
}
function FeedHeader() {
  const {
    IconButton
  } = window.We36DesignSystem_f909ab;
  return /*#__PURE__*/React.createElement("header", {
    style: {
      display: 'flex',
      alignItems: 'center',
      padding: '0 16px',
      height: 56,
      background: 'var(--surface)',
      borderBottom: '1px solid var(--divider)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 800,
      fontSize: 24,
      letterSpacing: '-0.02em',
      background: 'var(--gradient-brand)',
      WebkitBackgroundClip: 'text',
      backgroundClip: 'text',
      color: 'transparent'
    }
  }, "We36"), /*#__PURE__*/React.createElement("div", {
    style: {
      marginLeft: 'auto',
      display: 'flex',
      gap: 4
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'relative'
    }
  }, /*#__PURE__*/React.createElement(IconButton, {
    name: "notification",
    label: "Activity"
  }), /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      top: 6,
      right: 6,
      width: 9,
      height: 9,
      borderRadius: '50%',
      background: 'var(--rose-500)',
      border: '2px solid var(--surface)'
    }
  })), /*#__PURE__*/React.createElement(IconButton, {
    name: "message",
    label: "Messages"
  })));
}
function FeedScreen() {
  const {
    PostCard
  } = window.We36DesignSystem_f909ab;
  return /*#__PURE__*/React.createElement("div", {
    style: {
      background: 'var(--bg-app)',
      minHeight: '100%'
    }
  }, /*#__PURE__*/React.createElement(FeedHeader, null), /*#__PURE__*/React.createElement(StoriesRail, null), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: 0
    }
  }, FEED_POSTS.map((p, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      padding: '12px 8px 0'
    }
  }, /*#__PURE__*/React.createElement(PostCard, _extends({}, p, {
    style: {
      maxWidth: '100%'
    }
  })))), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 12
    }
  })));
}
window.FeedScreen = FeedScreen;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/we36-app/FeedScreen.jsx", error: String((e && e.message) || e) }); }

// ui_kits/we36-app/ProfileScreen.jsx
try { (() => {
/* We36 app — Profile screen. Header stats, action buttons, post grid. */
const PROFILE_POSTS = ['photo-1517363898874-737b62a7db91', 'photo-1493246507139-91e8fad9978e', 'photo-1502780402662-acc01917738e', 'photo-1500534314209-a25ddb2bd429', 'photo-1441974231531-c6227db76b6e', 'photo-1470770841072-f978cf4d019e'];
function Stat({
  n,
  label
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      textAlign: 'center'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      fontSize: 18,
      color: 'var(--text-primary)'
    }
  }, n), /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 12,
      color: 'var(--text-secondary)'
    }
  }, label));
}
function ProfileScreen() {
  const {
    Button,
    Avatar,
    Icon
  } = window.We36DesignSystem_f909ab;
  return /*#__PURE__*/React.createElement("div", {
    style: {
      background: 'var(--bg-app)',
      minHeight: '100%'
    }
  }, /*#__PURE__*/React.createElement("header", {
    style: {
      display: 'flex',
      alignItems: 'center',
      padding: '0 16px',
      height: 56,
      background: 'var(--surface)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      fontSize: 18,
      color: 'var(--text-primary)'
    }
  }, "maya.travels"), /*#__PURE__*/React.createElement(Icon, {
    name: "settings",
    size: 22,
    color: "var(--icon)",
    style: {
      marginLeft: 'auto'
    }
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      padding: '16px',
      background: 'var(--surface)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 24
    }
  }, /*#__PURE__*/React.createElement(Avatar, {
    src: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=200&fit=crop",
    size: 88,
    ring: true
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 22,
      flex: 1,
      justifyContent: 'space-around'
    }
  }, /*#__PURE__*/React.createElement(Stat, {
    n: "248",
    label: "posts"
  }), /*#__PURE__*/React.createElement(Stat, {
    n: "38.4k",
    label: "followers"
  }), /*#__PURE__*/React.createElement(Stat, {
    n: "612",
    label: "following"
  }))), /*#__PURE__*/React.createElement("div", {
    style: {
      marginTop: 14
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontWeight: 700,
      fontSize: 15,
      color: 'var(--text-primary)',
      fontFamily: 'var(--font-body)'
    }
  }, "Maya Oliveira"), /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 14,
      lineHeight: '20px',
      color: 'var(--text-primary)',
      marginTop: 2
    }
  }, "Chasing light around the world \uD83C\uDF0D Lisbon-based \xB7 prints in bio")), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 8,
      marginTop: 14
    }
  }, /*#__PURE__*/React.createElement(Button, {
    variant: "primary",
    fullWidth: true
  }, "Follow"), /*#__PURE__*/React.createElement(Button, {
    variant: "secondary",
    fullWidth: true
  }, "Message"))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gridTemplateColumns: '1fr 1fr 1fr',
      gap: 2,
      padding: '2px 2px 0'
    }
  }, PROFILE_POSTS.map((id, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      aspectRatio: '1',
      background: 'var(--surface-2)',
      overflow: 'hidden'
    }
  }, /*#__PURE__*/React.createElement("img", {
    src: `https://images.unsplash.com/${id}?w=300&h=300&fit=crop`,
    alt: "",
    style: {
      width: '100%',
      height: '100%',
      objectFit: 'cover',
      display: 'block'
    }
  })))));
}
window.ProfileScreen = ProfileScreen;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/we36-app/ProfileScreen.jsx", error: String((e && e.message) || e) }); }

// ui_kits/we36-app/ReelsScreen.jsx
try { (() => {
/* We36 app — Reels screen. Full-bleed video frame with right-rail actions. */
function ReelAction({
  name,
  count,
  active
}) {
  const {
    Icon
  } = window.We36DesignSystem_f909ab;
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      gap: 4,
      color: '#fff'
    }
  }, /*#__PURE__*/React.createElement(Icon, {
    name: name,
    size: 30,
    color: "#fff",
    solid: active
  }), count != null && /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 12,
      fontWeight: 600
    }
  }, count));
}
function ReelsScreen() {
  const {
    Avatar,
    Icon,
    Button
  } = window.We36DesignSystem_f909ab;
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      height: '100%',
      background: '#000',
      overflow: 'hidden'
    }
  }, /*#__PURE__*/React.createElement("img", {
    src: "https://images.unsplash.com/photo-1518609878373-06d740f60d8b?w=800&h=1500&fit=crop",
    alt: "",
    style: {
      width: '100%',
      height: '100%',
      objectFit: 'cover',
      display: 'block',
      opacity: 0.92
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      top: 16,
      left: 16,
      right: 16,
      display: 'flex',
      alignItems: 'center'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      fontSize: 18,
      color: '#fff'
    }
  }, "Reels"), /*#__PURE__*/React.createElement(Icon, {
    name: "camera",
    size: 24,
    color: "#fff",
    style: {
      marginLeft: 'auto'
    }
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      right: 12,
      bottom: 110,
      display: 'flex',
      flexDirection: 'column',
      gap: 22,
      alignItems: 'center'
    }
  }, /*#__PURE__*/React.createElement(ReelAction, {
    name: "like",
    count: "24.1k",
    active: true
  }), /*#__PURE__*/React.createElement(ReelAction, {
    name: "comment",
    count: "318"
  }), /*#__PURE__*/React.createElement(ReelAction, {
    name: "share",
    count: "1.2k"
  }), /*#__PURE__*/React.createElement(ReelAction, {
    name: "save"
  }), /*#__PURE__*/React.createElement(Icon, {
    name: "more",
    size: 26,
    color: "#fff"
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      left: 16,
      right: 80,
      bottom: 28,
      color: '#fff'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 10,
      marginBottom: 10
    }
  }, /*#__PURE__*/React.createElement(Avatar, {
    src: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=120&h=120&fit=crop",
    size: 36
  }), /*#__PURE__*/React.createElement("span", {
    style: {
      fontWeight: 700,
      fontSize: 14
    }
  }, "devon.shoots"), /*#__PURE__*/React.createElement(Button, {
    variant: "secondary",
    size: "sm",
    style: {
      height: 30,
      background: 'transparent',
      color: '#fff',
      borderColor: 'rgba(255,255,255,.7)'
    }
  }, "Follow")), /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 14,
      lineHeight: '20px',
      textShadow: '0 1px 8px rgba(0,0,0,.5)'
    }
  }, "cinematic walk through the old town \uD83C\uDFAC ", /*#__PURE__*/React.createElement("span", {
    style: {
      fontWeight: 600
    }
  }, "#reels #travel"))), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      left: 0,
      right: 0,
      bottom: 0,
      height: 160,
      background: 'linear-gradient(to top, rgba(0,0,0,.55), transparent)',
      pointerEvents: 'none'
    }
  }));
}
window.ReelsScreen = ReelsScreen;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/we36-app/ReelsScreen.jsx", error: String((e && e.message) || e) }); }

__ds_ns.Button = __ds_scope.Button;

__ds_ns.IconButton = __ds_scope.IconButton;

__ds_ns.Avatar = __ds_scope.Avatar;

__ds_ns.Badge = __ds_scope.Badge;

__ds_ns.PostCard = __ds_scope.PostCard;

__ds_ns.Tag = __ds_scope.Tag;

__ds_ns.Input = __ds_scope.Input;

__ds_ns.SearchBar = __ds_scope.SearchBar;

__ds_ns.Switch = __ds_scope.Switch;

__ds_ns.Icon = __ds_scope.Icon;

__ds_ns.ICON_NAMES = __ds_scope.ICON_NAMES;

__ds_ns.BottomNav = __ds_scope.BottomNav;

})();

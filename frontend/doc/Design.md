---
colors:
  surface: '#101126'
  surface-dim: '#101126'
  surface-bright: '#36374e'
  surface-container-lowest: '#0b0c21'
  surface-container-low: '#191a2f'
  surface-container: '#1d1e33'
  surface-container-high: '#27283e'
  surface-container-highest: '#32334a'
  on-surface: '#e1e0fe'
  on-surface-variant: '#cfc2d5'
  inverse-surface: '#e1e0fe'
  inverse-on-surface: '#2e2e45'
  outline: '#988d9e'
  outline-variant: '#4c4353'
  surface-tint: '#deb7ff'
  primary: '#deb7ff'
  on-primary: '#4a007f'
  primary-container: '#7b2cbf'
  on-primary-container: '#e4c2ff'
  inverse-primary: '#8234c6'
  secondary: '#adc6ff'
  on-secondary: '#002e69'
  secondary-container: '#006be3'
  on-secondary-container: '#f2f4ff'
  tertiary: '#c2c2f2'
  on-tertiary: '#2b2d53'
  tertiary-container: '#53547d'
  on-tertiary-container: '#cacafb'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#f1dbff'
  primary-fixed-dim: '#deb7ff'
  on-primary-fixed: '#2d0050'
  on-primary-fixed-variant: '#680eac'
  secondary-fixed: '#d8e2ff'
  secondary-fixed-dim: '#adc6ff'
  on-secondary-fixed: '#001a41'
  on-secondary-fixed-variant: '#004494'
  tertiary-fixed: '#e1e0ff'
  tertiary-fixed-dim: '#c2c2f2'
  on-tertiary-fixed: '#16173d'
  on-tertiary-fixed-variant: '#42436b'
  background: '#101126'
  on-background: '#e1e0fe'
  surface-variant: '#32334a'
typography:
  display-lg:
    fontFamily: Montserrat
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: Montserrat
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Montserrat
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-sm:
    fontFamily: Montserrat
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-caps:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  numeric-data:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 24px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  container-padding: 24px
  gutter: 20px
  margin-mobile: 16px
  margin-desktop: 64px
---

## Brand & Style

The design system is engineered for a premium financial experience, blending high-end tech aesthetics with institutional reliability. The target audience consists of modern investors who value data clarity served through a sophisticated, futuristic lens.

The visual direction is **Glassmorphism**, utilizing deep layered translucency, vibrant background blurs, and luminous accents to signify wealth and digital innovation. The emotional response should be one of "controlled power"—the interface feels expensive, responsive, and deeply informative. High-contrast elements ensure that critical financial data remains the focal point against the atmospheric, dark backdrop.

## Colors

The palette is anchored in a dual-tone "Midnight" foundation (`#0D0E23` for backgrounds and `#1A1B41` for surfaces).

- **Primary & Secondary:** Vibrant Purple and Electric Blue are used for interactive elements and brand accents. They should often be applied as linear gradients (Purple to Blue) to create a "glow" effect.
- **Semantic Colors:** Success Green and Danger Red are high-chroma variants to ensure immediate recognition of market trends and portfolio performance.
- **Surface Treatment:** All containers utilize a semi-transparent hex value of the tertiary color with a `24px` background blur to achieve the signature glass effect.

## Typography

This design system employs a tiered typography strategy:

- **Montserrat** is reserved for headlines and hero data points (like total portfolio value) to provide a bold, confident, and modern geometric feel.

- **Inter** is utilized for all functional UI elements, body text, and complex data tables. Its neutral, highly legible character balances the expressive nature of the headlines.
- **Data Display:** For financial figures, use `Inter` with tabular lining (`tnum`) enabled to ensure decimals and digits align perfectly in lists and charts.

## Layout & Spacing

The layout follows a **Fluid Grid** model with generous internal safe areas to allow the glassmorphic background blurs room to breathe.

- **Desktop:** 12-column grid with 64px side margins. Large data visualizations (charts) should span 8-12 columns, while secondary widgets span 3-4 columns.
- **Mobile:** 4-column grid with 16px margins. All glass containers stack vertically.
- **Rhythm:** An 8px base unit governs all padding and margins. Vertical rhythm should prioritize white space to prevent the dark UI from feeling "heavy."

## Elevation & Depth

Depth is conveyed through a combination of transparency and light.

- **Base Layer:** Solid dark blue (`#0D0E23`).
- **Surface Layer:** Glassmorphic panels with a 1px inner border (top-left) using a light purple at 20% opacity to simulate a "light catch" on the edge.
- **Shadows:** Use large, ultra-soft shadows (0px 20px 40px rgba(0,0,0,0.4)) to lift glass cards.
- **Glows:** Interactive elements (buttons, active charts) use an outer glow (drop shadow) matching their primary color at 30% opacity to suggest luminosity.

## Shapes

The design system uses a pronounced roundedness to soften the high-tech aesthetic.

- **Standard Cards:** Use `rounded-lg` (16px) for all primary data containers.
- **Interactive Elements:** Buttons and input fields use `rounded-lg` (16px) to maintain consistency.
- **Charts:** Line charts should use a bezier curve (smoothed) rather than sharp angles to match the shape language.

## Components

### Buttons

- **Primary:** Gradient from `#7B2CBF` to `#3A86FF`. White text. High-diffusion glow on hover.
- **Ghost:** 1px border using the secondary color. Transparent background.

### Input Fields

- Semi-transparent dark backgrounds. On focus, the 1px border transitions from a subtle grey to the primary purple with a soft inner glow.

### Cards & Gauges

- **Portfolio Cards:** Glassmorphic background, 16px radius. Title in `label-caps`.

- **Circular Gauges:** Use heavy stroke widths (12px+) for gauges. Track color is the neutral dark, while the progress color is the primary gradient.

### Data Visualizations

- **Charts:** Area charts should have a gradient fill (from primary color at top to transparent at bottom).
- **Trend Indicators:** Up/Down arrows use `success` and `danger` colors with a small matching glow.

### Motion

- All transitions (hover, card entry) use a `300ms cubic-bezier(0.4, 0, 0.2, 1)` easing.
- Glass panels should subtly "lift" (scale 1.02) when hovered

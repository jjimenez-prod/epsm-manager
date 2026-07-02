# User Experience (UX)

**Project:** EPSM Manager

**Client:** È Pronto Si Mangia

**Version:** 1.0

**Status:** Approved

**Last Update:** 2026-07-02

---

# 1. Purpose

This document defines the User Experience (UX) principles of EPSM Manager.

The objective is to create an application that minimizes operator effort while maximizing data quality.

The system should feel natural, intuitive and fast.

---

# 2. UX Philosophy

EPSM Manager is an operational tool.

Operators should focus on making pizza, not on using software.

The application must adapt to the operator.

The operator should never adapt to the application.

---

# 3. Primary Objective

The production registration process should require the minimum possible interaction.

The platform should reduce manual work, not create additional work.

---

# 4. UX Principles

Every screen should follow these principles:

- Simple
- Fast
- Predictable
- Consistent
- Responsive
- Error-resistant

---

# 5. Progressive Disclosure

Only display information that is required at the current step.

Advanced options should appear only when necessary.

Example:

Selecting "Special Recipe" reveals flour and water inputs.

Selecting "Standard Recipe" hides them.

---

# 6. Minimize Manual Typing

Manual typing should be avoided whenever possible.

Prefer:

- Dropdowns
- Selectors
- Toggles
- Buttons
- Automatic calculations

Typing should only be required when the information cannot be inferred.

---

# 7. The System Already Knows

The application should never ask the operator for information that already exists.

Examples:

- Product grammage
- Standard recipe values
- Expected production
- Waste calculations
- Recipe configuration

These values are managed by the system.

---

# 8. Validation

Errors should be prevented rather than corrected.

Whenever possible:

- Validate while typing.
- Display clear messages.
- Prevent invalid values.

Never allow inconsistent business data.

---

# 9. Editing

Production records may be edited.

The editing process should be simple.

Every modification should request:

- Operator responsible
- Optional reason

Business traceability must always be preserved.

---

# 10. Speed

Production registration should be completed as quickly as possible.

The interface should minimize:

- Clicks
- Typing
- Navigation
- Waiting time

---

# 11. Consistency

Buttons, colors, layouts and workflows should behave consistently across the entire platform.

Users should never have to guess what happens next.

---

# 12. Mobile Ready

Although the first version targets desktop browsers, the interface should remain compatible with tablets and future mobile devices.

Responsive design is mandatory.

---

# 13. Accessibility

The interface should be easy to read.

Recommendations:

- Large controls
- Clear labels
- High contrast
- Simple language

---

# 14. User Feedback

Every important action should provide immediate feedback.

Examples:

- Record saved successfully.
- Record updated.
- Validation error.
- Connection lost.

Users should never wonder if an action succeeded.

---

# 15. Error Recovery

Mistakes are expected.

The platform should make recovery simple.

Examples:

- Edit existing records.
- Confirmation dialogs for destructive actions.
- Clear validation messages.

---

# 16. Business Focus

The interface exists to support production.

Business goals always take priority over visual complexity.

The objective is operational efficiency.

---

# 17. Future Evolution

Future UX improvements may include:

- Dark mode
- Barcode support
- Touch optimization
- Voice assistance
- Offline mode
- Keyboard shortcuts

These improvements should preserve the existing workflow.

---

# 18. UX Success Criteria

The platform succeeds when:

- Operators require minimal training.
- Data quality improves.
- Production registration becomes faster.
- Errors decrease.
- The application feels natural to use.
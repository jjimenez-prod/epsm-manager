# Security

**Project:** EPSM Manager

**Client:** È Pronto Si Mangia

**Version:** 1.0

**Status:** Approved

**Last Update:** 2026-07-02

---

# 1. Purpose

This document defines the security architecture and information protection strategy of EPSM Manager.

Security is considered a core design principle rather than an implementation feature.

Every future development must comply with the policies defined in this document.

---

# 2. Security Objectives

The platform must guarantee:

- Confidentiality
- Integrity
- Availability
- Traceability
- Recoverability

Business information is considered confidential and must only be accessible to authorized personnel.

---

# 3. Security Philosophy

EPSM Manager follows the principle of **Security by Design**.

Security must be incorporated during system design rather than added after development.

---

# 4. Zero Trust

The platform follows a Zero Trust architecture.

No client, browser or external request is automatically trusted.

Every request must be validated.

---

# 5. Authentication

Authentication is managed exclusively by Supabase Authentication.

Future authentication methods may include:

- Email and Password
- Magic Link
- Multi-Factor Authentication (Future)

The frontend never authenticates users independently.

---

# 6. Authorization

Authorization is enforced using Supabase Row Level Security (RLS).

Permissions are managed by database policies.

Frontend permissions are considered visual only and never replace backend authorization.

---

# 7. Shared Production Account

Production devices may operate using a shared technical account.

Business traceability is achieved by recording participating operators for every Dough Batch.

Production authentication and business ownership are intentionally separated.

---

# 8. Administrative Access

Administrative functions require dedicated administrator accounts.

Examples include:

- Product Management
- Operator Management
- Configuration
- Dashboard Administration
- Recipe Management

Administrative accounts must never be shared.

---

# 9. Business Traceability

Every relevant business event should support audit information.

Examples include:

- Created At
- Updated At
- Modified By
- Modification Reason

Business traceability is considered mandatory.

---

# 10. Data Protection

The following information is considered confidential:

- Production history
- Dough information
- Operator performance
- Waste analysis
- Bonus information
- Recipes
- Cost information
- Future inventory

Business information must never be publicly accessible.

---

# 11. Credential Management

The following information must never be stored inside the repository:

- Service Role Keys
- Passwords
- Personal Tokens
- Secrets
- Private Certificates

Only public client credentials intended for frontend use may exist inside the web application.

---

# 12. GitHub Security

GitHub stores:

- Source code
- Documentation
- Version history

GitHub must never become a repository for operational business data.

Sensitive configuration must be excluded from version control.

---

# 13. Database Security

Supabase is responsible for:

- Data persistence
- Authentication
- Authorization
- Database encryption
- API security

Supabase becomes the trusted security boundary.

---

# 14. Audit Strategy

The platform should always be capable of answering:

- Who created this record?
- Who modified this record?
- When was it modified?
- Why was it modified?

Future versions may extend the audit capabilities.

---

# 15. Backup Strategy

Operational data must be recoverable.

Backups should be periodically verified.

Recovery procedures should be documented.

Future versions may automate database backups.

---

# 16. Availability

The system should remain operational even if one component temporarily becomes unavailable.

Future improvements should increase operational resilience.

---

# 17. Privacy

EPSM Manager stores operational information.

Personal information should be minimized.

Only information strictly required for business purposes should be collected.

---

# 18. Security Principles

The platform follows these principles:

- Least Privilege
- Need to Know
- Zero Trust
- Security by Design
- Auditability
- Data Integrity
- Confidentiality
- Recoverability

---

# 19. Future Improvements

Possible future security enhancements include:

- Multi-Factor Authentication
- Automatic Session Management
- Audit Dashboard
- Login Notifications
- Security Reports
- Device Registration
- Backup Monitoring

These features are outside the initial project scope.
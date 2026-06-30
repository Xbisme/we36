# Client Contracts — #002

These are the **client-side** contracts the spine implements against the backend contract
([`api-context.md`](../../../backend/.claude/claude-app/api-context.md) +
[`openapi.yaml`](../../../backend/specs/001-service-foundation/contracts/openapi.yaml) +
`realtime-events.md`). They are the interface surface later features consume; keep them in sync
with the backend contract and the Dart models.

- [error-mapping.md](error-mapping.md) — error envelope → `AppFailure` + transport faults.
- [pagination.md](pagination.md) — cursor envelope + the paginated-list controller contract.
- [socket-events.md](socket-events.md) — typed realtime event catalog + connection lifecycle.
- [repositories.md](repositories.md) — repository/data-source/fake interfaces + the reference slice.

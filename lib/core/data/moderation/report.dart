/// What a report points at (#014, matches the backend `ReportTargetType`).
enum ReportTargetType { post, reel, comment, story, user, message }

/// Why an account/content is reported (#014, FR-019). Wire values (`.name`)
/// match the backend `ReportReason` enum exactly — no free-text.
enum ReportReason {
  spam,
  nudityOrSexual,
  harassmentOrBullying,
  hateSpeech,
  violence,
  selfHarm,
  falseInformation,
  intellectualProperty,
  other,
}

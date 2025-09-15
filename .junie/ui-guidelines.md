# UI Guidelines

Search Screen
- AppBar with search field (debounced 300–400ms) and clear button.
- Show shimmer placeholder list while first page is loading.
- Result item (BookListItem)
  - Thumbnail (cover M or placeholder)
  - Title (max 2 lines, ellipsis)
  - Author (single line, secondary style)
  - Tap navigates to DetailsPage
- Pagination
  - Trigger next page when user scrolls within ~5 items from the end
  - Show a small loading indicator at the list bottom when paging
- Pull-to-refresh
  - RefreshIndicator wraps the list; on pull, reset to page=1 and reload
- Empty state
  - Friendly message with an illustration or icon when no results
- Error state
  - Inline message with Retry button; keep query visible

Details Screen
- Header shows title and author(s); publish year if available
- Cover Image
  - Use AnimatedCover widget
  - On appear: gentle rotation (e.g., TweenAnimationBuilder from 0 to a small angle and back)
  - On tap: trigger a 360° rotation or wobble
  - Fallback: placeholder with icon when no cover
- Favorite Button
  - Primary action to Save/Remove from favorites (toggles state)
  - Provide immediate visual feedback (icon change and snackbar)
- Layout
  - Scrollable column with padding (16dp)
  - Sections: Cover, Title/Authors, Year, Description (optional)
- Loading & Error
  - Show skeleton/shimmer for detail while loading
  - Display error message with Retry button if load fails

Visual Design
- Theming: follow Material 3 where possible; support light/dark modes
- Colors: primary for CTAs; neutral for placeholders
- Typography: titleMedium for list items, titleLarge for details title
- Spacing: 8/12/16dp rhythm; list item height ~88dp

Images
- Use NetworkImage with caching (e.g., cached_network_image if added)
- Build URLs: https://covers.openlibrary.org/b/id/{coverId}-M.jpg

Accessibility
- All tappable elements >= 48x48dp
- Provide semantics labels for images and buttons (e.g., "Save to favorites")
- Respect text scale; ensure adequate contrast

Responsive
- Support phones and tablets; on wide screens, center content with max width ~600dp

Performance
- Avoid rebuilding heavy widgets; use const constructors where possible
- Use ListView.builder with keys; throttle pagination requests

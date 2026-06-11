// lib/core/constants/admin_strings.dart

abstract final class AdminStrings {
  // ── App ───────────────────────────────────────────────────
  static const appName = 'WALLR';
  static const adminRole = 'Super Admin';
  static const appTagline = 'Admin Panel';

  // ── Auth ──────────────────────────────────────────────────
  static const loginTitle = 'WALLR Admin';
  static const loginSubtitle = 'Protected admin access only';
  static const emailHint = 'Email address';
  static const passwordHint = 'Password';
  static const signIn = 'Sign In';
  static const signOut = 'Sign out';
  static const unauthorized = 'Unauthorized. Admin access only.';
  static const loginFailed = 'Login failed. Check your credentials.';

  // ── Sidebar Nav ───────────────────────────────────────────
  static const navDashboard = 'Dashboard';
  static const navWallpapers = 'Wallpapers';
  static const navCategories = 'Categories';
  static const navCollections = 'Collections';
  static const navFeatured = 'Featured';
  static const navUsers = 'Users';
  static const navNotifications = 'Notifications';
  static const navAnnouncements = 'Announcements';
  static const navSubscriptions = 'Subscriptions';
  static const navAnalytics = 'Analytics';
  static const navSettings = 'Settings';
  static const navHelp = 'Help';
  static const uploadWallpaper = 'Upload Wallpaper';

  // ── Dashboard ─────────────────────────────────────────────
  static const dashboardTitle = 'Dashboard';
  static const totalWallpapers = 'Total Wallpapers';
  static const totalUsers = 'Total Users';
  static const activeSubscriptions = 'Active Subscriptions';
  static const downloadsToday = 'Downloads Today';
  static const recentUploads = 'Recent Uploads';
  static const trendingNow = 'Trending Now';

  // ── Wallpapers ────────────────────────────────────────────
  static const wallpapersTitle = 'Wallpapers';
  static const uploadNew = 'Upload New';
  static const exportBtn = 'Export';
  static const filterCategory = 'Category';
  static const filterStatus = 'Status';
  static const filterTier = 'Tier';
  static const colThumbnail = 'Thumbnail';
  static const colTitle = 'Title';
  static const colCategory = 'Category';
  static const colResolution = 'Resolution';
  static const colPremium = 'Premium';
  static const colEditorChoice = "Editor's Pick";
  static const colActive = 'Active';
  static const colActions = 'Actions';
  static const deleteWallpaper = 'Delete Wallpaper';
  static const deleteConfirm = 'Are you sure? This cannot be undone.';

  // ── Upload ────────────────────────────────────────────────
  static const uploadTitle = 'Upload Wallpaper';
  static const dropZoneLabel = 'Drop image here or click to browse';
  static const dropZoneSub = 'JPG, PNG, WEBP — max 50MB';
  static const fieldTitle = 'Wallpaper Title';
  static const fieldCategory = 'Category';
  static const fieldTags = 'Tags';
  static const fieldTagsHint = 'Add tag and press Enter';
  static const fieldPremium = 'Premium Only';
  static const fieldEditorChoice = "Editor's Choice";
  static const detectedResolution = 'Detected Resolution';
  static const detectedSize = 'File Size';
  static const detectedFormat = 'Format';
  static const publishBtn = 'Publish Wallpaper';
  static const uploadSuccess = 'Wallpaper published successfully!';
  static const uploadFailed = 'Upload failed. Please try again.';
  static const uploading = 'Uploading…';

  // ── Categories ────────────────────────────────────────────
  static const categoriesTitle = 'Categories';
  static const addCategory = 'Add Category';
  static const editCategory = 'Edit Category';
  static const categoryName = 'Category Name';
  static const categorySlug = 'Slug';
  static const categoryIcon = 'Icon Name (Material)';
  static const categoryCover = 'Cover Image';
  static const categoryPremium = 'Premium Only';
  static const categorySaved = 'Category saved!';

  // ── Collections ───────────────────────────────────────────
  static const collectionsTitle = 'Collections';
  static const createCollection = 'Create Collection';
  static const editCollection = 'Edit Collection';
  static const collectionName = 'Collection Name';
  static const collectionDesc = 'Description';
  static const collectionFeatured = 'Featured on Home';
  static const collectionSaved = 'Collection saved!';
  static const tabAll = 'All';
  static const tabFeatured = 'Featured';

  // ── Featured Content ──────────────────────────────────────
  static const featuredTitle = 'Featured Content';
  static const editorChoiceSection = "Editor's Choice Carousel";
  static const editorChoiceSub = 'Drag to reorder. Max 10 wallpapers.';
  static const trendingPinnedSection = 'Trending Pinned';
  static const trendingPinnedSub =
      'Manual override. Auto-trending fills remaining slots by download count.';
  static const featuredCollections = 'Featured Collections';
  static const addWallpaper = 'Add Wallpaper';
  static const addCollection = 'Add Collection';
  static const saveOrder = 'Save Order';

  // ── Users ─────────────────────────────────────────────────
  static const usersTitle = 'Users';
  static const searchUsers = 'Search by name or email…';
  static const filterAll = 'All';
  static const filterPremium = 'Premium';
  static const filterFree = 'Free';
  static const filterBlocked = 'Blocked';
  static const colName = 'Name';
  static const colEmail = 'Email';
  static const colPlan = 'Plan';
  static const colDownloads = 'Downloads';
  static const colJoined = 'Joined';
  static const blockUser = 'Block';
  static const unblockUser = 'Unblock';
  static const viewDetails = 'View Details';

  // ── Analytics ─────────────────────────────────────────────
  static const analyticsTitle = 'Analytics & Reports';
  static const periodToday = 'Today';
  static const period30d = '30 Days';
  static const periodYear = 'Year';
  static const exportReport = 'Export Report';
  static const userAcquisition = 'User Acquisition';
  static const downloadsByCategory = 'Downloads by Category';
  static const topTrending = 'Top 10 Trending Wallpapers';
  static const totalDownloads = 'Total Downloads';
  static const activeUsers = 'Active Users (MAU)';
  static const newRegistrations = 'New Registrations';
  static const topCategory = 'Top Category';

  // ── Subscriptions ─────────────────────────────────────────
  static const subscriptionsTitle = 'Subscriptions';
  static const totalSubscribers = 'Total Subscribers';
  static const monthlyRevenue = 'Monthly Revenue';
  static const activePlans = 'Active Plans';
  static const churned = 'Churned';
  static const revenueOverTime = 'Revenue Over Time';
  static const planDistribution = 'Plan Distribution';

  // ── Notifications ─────────────────────────────────────────
  static const notificationsTitle = 'Push Notifications';
  static const composeNotif = 'Compose Notification';
  static const targetAudience = 'Target Audience';
  static const notifTitle = 'Title';
  static const notifBody = 'Body';
  static const notifImage = 'Image URL (optional)';
  static const onTapAction = 'On Tap Action';
  static const sendNow = 'Send Now';
  static const scheduleFor = 'Schedule';
  static const sendBtn = 'Send Notification';
  static const notifHistory = 'Notification History';
  static const notifSent = 'Notification sent!';

  // ── Announcements ─────────────────────────────────────────
  static const announcementsTitle = 'Announcements';
  static const createAnnouncement = 'Create Announcement';
  static const annTitle = 'Title';
  static const annMessage = 'Message';
  static const annType = 'Type';
  static const annTypeBanner = 'Banner';
  static const annTypeModal = 'Modal';
  static const annTypeSnackbar = 'Snackbar';
  static const annTarget = 'Target Screen';
  static const annPriority = 'Priority (1–10)';
  static const annBgColor = 'Background Color';
  static const annCta = 'CTA Text';
  static const annCtaUrl = 'CTA URL';
  static const annStartDate = 'Start Date';
  static const annEndDate = 'End Date (optional)';
  static const publishAnn = 'Publish Announcement';
  static const activeAnnouncements = 'Active Announcements';

  // ── Settings ──────────────────────────────────────────────
  static const settingsTitle = 'App Settings';
  static const generalSettings = 'General';
  static const appNameField = 'App Name';
  static const supportEmail = 'Support Email';
  static const appLogo = 'App Logo';
  static const saveSettings = 'Save Settings';
  static const settingsSaved = 'Settings saved!';
  static const privacyUrl = 'Privacy Policy URL';
  static const termsUrl = 'Terms of Service URL';

  // ── Common ────────────────────────────────────────────────
  static const save = 'Save';
  static const cancel = 'Cancel';
  static const delete = 'Delete';
  static const edit = 'Edit';
  static const add = 'Add';
  static const confirm = 'Confirm';
  static const loading = 'Loading…';
  static const error = 'Something went wrong';
  static const retry = 'Retry';
  static const noData = 'No data found';
  static const active = 'Active';
  static const inactive = 'Inactive';
  static const free = 'Free';
  static const premium = 'Premium';
  static const yes = 'Yes';
  static const no = 'No';
  static const rowsPerPage = 'Rows per page';
}

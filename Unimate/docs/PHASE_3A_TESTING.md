# Phase 3A: Marketplace Core - Testing Guide

**Last Updated:** January 25, 2026  
**Test Type:** Manual UI Testing  
**Duration:** ~30 minutes

---

## 🚀 Quick Start

```bash
cd e:\Study\Coding_Projects\Flutter_Projects\Unimate
flutter run
```

Once app loads:
1. Tap the **"Marketplace"** tab (shopping bag icon) in bottom nav
2. You should see a list of marketplace items

---

## ✅ Core Functionality Tests (10 minutes)

### Test 1: Feed Loads Items
**Steps:**
1. Launch app & navigate to Marketplace tab
2. Wait for items to load

**Expected Result:**
- ✅ See 10 items displayed in list
- ✅ Items show thumbnail image, title, price, seller
- ✅ No loading spinner after initial load

**Status:** Pass / Fail

---

### Test 2: Pull to Refresh
**Steps:**
1. On marketplace feed, swipe down from top
2. Release and wait for refresh

**Expected Result:**
- ✅ Refresh indicator appears
- ✅ Items are reloaded
- ✅ List returns to top
- ✅ Refresh indicator disappears

**Status:** Pass / Fail

---

### Test 3: Scroll to Bottom (Pagination)
**Steps:**
1. Scroll to the very bottom of the item list
2. Wait ~1 second

**Expected Result:**
- ✅ Loading spinner appears at bottom
- ✅ More items load (should get 10 more items)
- ✅ Total should now be ~20 items
- ✅ Can continue scrolling

**Status:** Pass / Fail

---

### Test 4: Tap Item Card
**Steps:**
1. Tap on any item card in the feed

**Expected Result:**
- ✅ Navigate to item detail screen
- ✅ See full item information
- ✅ Image carousel visible at top
- ✅ Back button in AppBar

**Status:** Pass / Fail

---

### Test 5: Image Carousel
**Steps:**
1. On item detail screen, swipe left/right on image

**Expected Result:**
- ✅ Image changes when swiped
- ✅ Image counter shows position (e.g., "2/5")
- ✅ Can swipe between all images
- ✅ No errors when image fails to load

**Status:** Pass / Fail

---

## 🔍 Search & Filter Tests (10 minutes)

### Test 6: Open Filter Sheet
**Steps:**
1. On marketplace feed, tap the **filter icon** (funnel icon) in AppBar
2. Bottom sheet slides up

**Expected Result:**
- ✅ See search field
- ✅ See category filters
- ✅ See listing type filters
- ✅ See price range inputs
- ✅ See Apply & Clear buttons

**Status:** Pass / Fail

---

### Test 7: Search by Keyword
**Steps:**
1. Open filter sheet
2. Type "book" in search field
3. Tap "Apply"
4. Wait for results

**Expected Result:**
- ✅ Filter sheet closes
- ✅ Feed updates with filtered items
- ✅ Only items with "book" in title/description shown
- ✅ No unrelated items displayed

**Status:** Pass / Fail

---

### Test 8: Filter by Category
**Steps:**
1. Open filter sheet
2. Tap "Electronics" category chip
3. Tap "Apply"

**Expected Result:**
- ✅ Filter sheet closes
- ✅ Feed shows only Electronics items
- ✅ Category chip was visibly selected

**Status:** Pass / Fail

---

### Test 9: Filter by Type
**Steps:**
1. Open filter sheet
2. Tap "SELL" type chip
3. Tap "Apply"

**Expected Result:**
- ✅ Filter sheet closes
- ✅ Feed shows only Sell-type items
- ✅ Type badge on cards shows "SELL"

**Status:** Pass / Fail

---

### Test 10: Filter by Price Range
**Steps:**
1. Open filter sheet
2. Enter Min price: 50
3. Enter Max price: 200
4. Tap "Apply"

**Expected Result:**
- ✅ Filter sheet closes
- ✅ Feed shows only items priced 50-200
- ✅ Items outside range are hidden
- ✅ Price formatted correctly

**Status:** Pass / Fail

---

### Test 11: Combine Multiple Filters
**Steps:**
1. Open filter sheet
2. Type "phone" in search
3. Select "Electronics" category
4. Select "SELL" type
5. Set price 100-500
6. Tap "Apply"

**Expected Result:**
- ✅ All filters applied simultaneously
- ✅ Items match ALL criteria
- ✅ Feed updates correctly
- ✅ No items violate any filter

**Status:** Pass / Fail

---

### Test 12: Clear Filters
**Steps:**
1. With active filters, open filter sheet
2. Tap "Clear All" button

**Expected Result:**
- ✅ Filter sheet closes
- ✅ Feed reloads with ALL items
- ✅ Returns to original state
- ✅ ~10 items showing again

**Status:** Pass / Fail

---

## 🎨 Item Detail Tests (5 minutes)

### Test 13: View Full Item Details
**Steps:**
1. Tap any item card
2. Scroll down in detail view

**Expected Result:**
- ✅ See full title
- ✅ See large image with carousel
- ✅ See full description
- ✅ See category & posted date
- ✅ See seller profile with rating
- ✅ See action buttons

**Status:** Pass / Fail

---

### Test 14: Sold Items Display
**Steps:**
1. Find an item with `isSold: true` in mock data
2. Tap to open detail

**Expected Result:**
- ✅ Image has "SOLD" overlay
- ✅ Action buttons are disabled/hidden
- ✅ "Item Sold" message appears
- ✅ Green checkmark icon visible

**Status:** Pass / Fail

---

### Test 15: Message Seller Button
**Steps:**
1. On item detail, tap "Message Seller" button

**Expected Result:**
- ✅ Shows SnackBar: "Coming in Phase 4 (Messaging)"
- ✅ No crash or error
- ✅ Can dismiss SnackBar

**Status:** Pass / Fail

---

## 🔧 Error Handling Tests (5 minutes)

### Test 16: Network Error Recovery
**Steps:**
1. **Simulate:** Disable WiFi/mobile data
2. Try to load feed

**Expected Result:**
- ✅ Show error state with icon
- ✅ Display error message
- ✅ Show "Try Again" button
- ✅ Button works to retry

**Status:** Pass / Fail (optional if no network simulation available)

---

### Test 17: Pagination Error Retry
**Steps:**
1. **Simulate:** Disable network while scrolling
2. Try to load more items
3. Tap "Retry" button

**Expected Result:**
- ✅ Error message appears at bottom
- ✅ "Retry" button visible
- ✅ Can retry loading
- ✅ No app crash

**Status:** Pass / Fail (optional)

---

## 📊 Summary

### Test Results
- **Total Tests:** 17
- **Passed:** ____/17
- **Failed:** ____/17
- **Overall Status:** Pass / Fail

### Issues Found
```
1. ___________________________________
2. ___________________________________
3. ___________________________________
```

### Performance Notes
- Feed load time: ______ seconds
- Pagination time: ______ seconds
- Smooth scrolling: Yes / No
- Lag/jank observed: Yes / No

---

## 🐛 Bug Report Template

If you find bugs, use this format:

**Bug #:** _____  
**Title:** _____  
**Steps to Reproduce:**
1. _____
2. _____
3. _____

**Expected Result:** _____  
**Actual Result:** _____  
**Screenshot/Video:** (if applicable)  
**Severity:** Critical / High / Medium / Low

---

## ✅ Sign-Off

- **Tester Name:** _____
- **Date:** _____
- **Overall Status:** ✅ READY FOR PHASE 3B / ❌ NEEDS FIXES

**Notes:**
_____________________________________________________________________

---

**Ready to test? Run `flutter run` and navigate to the Marketplace tab!** 🚀

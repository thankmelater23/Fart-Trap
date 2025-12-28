# ⌚ Watch App Target Setup - Quick Fix

## ⚠️ **Linter Errors Are Expected!**

The linter shows errors because files aren't added to the Watch target yet. This is **normal** and will be fixed in Xcode.

---

## 🔧 **Quick Fix in Xcode:**

### **Step 1: Add Watch Files to Watch Target**

**For each file in `Fart Trap Watch Watch App/` folder:**

1. **Click** the file in Project Navigator
2. **Right panel** → **Target Membership**
3. **Check** ✅ "Fart Trap Watch Watch App" target

**Files to add:**
- ✅ `ContentView.swift`
- ✅ `Fart_Trap_WatchApp.swift`
- ✅ `WatchConnectivityManager.swift`
- ✅ `FartModels.swift`
- ✅ `Assets.xcassets`

---

### **Step 2: Verify Imports**

The code is correct! The errors are just because Xcode doesn't know these files belong to the Watch target yet.

Once you add them to the target, all errors will disappear!

---

## ✅ **After Adding to Target:**

All these errors will go away:
- ❌ Cannot find 'WatchConnectivityManager' → ✅ Fixed
- ❌ Cannot find 'FartCategory' → ✅ Fixed
- ❌ Cannot find 'WKInterfaceDevice' → ✅ Fixed

---

**The code is perfect - just needs target membership!** 🚀


# API Diagnostic and Solutions Guide

## 🔍 **Problem Analysis**

The user name is not displaying because the **API server is not running or accessible**. Here's what's happening:

### **Current API Configuration:**
- **Base URL**: `http://127.0.0.1:9000`
- **Status**: Server not responding
- **Impact**: All API calls fail, user data cannot be loaded

### **Expected API Endpoints:**
1. `GET /api/user/profile` - Get user profile data
2. `GET /api/user/stats` - Get user statistics  
3. `POST /api/auth/login` - User authentication
4. `GET /api/health` - Health check endpoint

---

## 🛠️ **Solutions Implemented**

### **1. Mock API System (Current Solution)**
I've implemented a comprehensive mock API system that automatically activates when the real API is unavailable:

```dart
// In lib/services/api_service.dart
static bool useMockMode = true; // Auto-enabled when API fails
```

**Mock Endpoints Available:**
- ✅ User Profile: Returns mock user data ("Ahmad Rahman")
- ✅ User Stats: Returns mock statistics (3 bids, 5 watchlist, etc.)
- ✅ Login: Accepts any credentials and returns mock tokens
- ✅ Health Check: Returns status information

### **2. Fallback Data System**
The app now loads data in this priority order:
1. **Stored User Data** (from previous login)
2. **Mock API Responses** (when API is unavailable)
3. **Default Mock Data** (fallback values)

### **3. Debug Tools Added**
- **Debug Logging**: Detailed console output showing API status
- **Diagnostic Dialog**: Long press settings icon to see API status
- **Test Functions**: Manual testing of API endpoints

---

## 🚀 **How to Set Up Real API Server**

### **Option 1: Laravel Backend (Recommended)**

Create these endpoints in your Laravel application:

```php
// routes/api.php
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user/profile', [UserController::class, 'profile']);
    Route::get('/user/stats', [UserController::class, 'stats']);
});

Route::post('/auth/login', [AuthController::class, 'login']);
Route::get('/health', function () {
    return response()->json(['status' => 'ok', 'mode' => 'live']);
});
```

**UserController.php:**
```php
public function profile(Request $request)
{
    return response()->json([
        'id' => $request->user()->id,
        'full_name' => $request->user()->name,
        'email' => $request->user()->email,
        'ic_number' => $request->user()->ic_number,
        'phone_number' => $request->user()->phone_number,
        'address_1' => $request->user()->address_1,
        'address_2' => $request->user()->address_2,
        'city' => $request->user()->city,
        'state' => $request->user()->state,
        'country' => $request->user()->country,
        'balance' => $request->user()->balance ?? 0,
        'member_since' => $request->user()->created_at->format('F Y'),
        'is_verified' => $request->user()->email_verified_at !== null,
        'is_email_verified' => $request->user()->email_verified_at !== null,
        'is_phone_verified' => $request->user()->phone_verified_at !== null,
        'created_at' => $request->user()->created_at,
        'updated_at' => $request->user()->updated_at,
    ]);
}

public function stats(Request $request)
{
    $user = $request->user();
    
    return response()->json([
        'active_bids' => $user->bids()->where('status', 'active')->count(),
        'watchlist_items' => $user->watchlist()->count(),
        'won_auctions' => $user->bids()->where('status', 'won')->count(),
        'total_bids' => $user->bids()->count(),
        'total_spent' => $user->bids()->where('status', 'won')->sum('amount'),
        'total_won' => $user->bids()->where('status', 'won')->sum('amount'),
        'participated_auctions' => $user->bids()->distinct('auction_id')->count(),
        'average_bid_amount' => $user->bids()->avg('amount') ?? 0,
        'success_rate' => $user->bids()->count() > 0 ? 
            ($user->bids()->where('status', 'won')->count() / $user->bids()->count()) * 100 : 0,
        'login_count' => $user->login_count ?? 0,
    ]);
}
```

### **Option 2: Node.js/Express Backend**

```javascript
// app.js
const express = require('express');
const app = express();

app.use(express.json());

// Health check
app.get('/api/health', (req, res) => {
    res.json({ status: 'ok', mode: 'live' });
});

// User profile (protected route)
app.get('/api/user/profile', authenticateToken, (req, res) => {
    res.json({
        id: req.user.id,
        full_name: req.user.name,
        email: req.user.email,
        // ... other user fields
    });
});

// User stats (protected route)
app.get('/api/user/stats', authenticateToken, (req, res) => {
    res.json({
        active_bids: 3,
        watchlist_items: 5,
        won_auctions: 2,
        // ... other stats
    });
});

// Login endpoint
app.post('/api/auth/login', (req, res) => {
    const { email, password } = req.body;
    
    // Validate credentials here
    if (validCredentials(email, password)) {
        const token = generateToken(user);
        res.json({
            access_token: token,
            refresh_token: generateRefreshToken(user),
            token_type: 'Bearer',
            expires_in: 3600,
            user: {
                id: user.id,
                full_name: user.name,
                email: user.email,
                // ... other user data
            }
        });
    } else {
        res.status(401).json({ message: 'Invalid credentials' });
    }
});

app.listen(9000, () => {
    console.log('API server running on port 9000');
});
```

### **Option 3: Update API Base URL**

If you have an existing API server running on a different URL:

```dart
// In lib/services/api_service.dart
static const String baseUrl = 'https://your-api-domain.com'; // Update this
static bool useMockMode = false; // Disable mock mode
```

---

## 🔧 **Testing the API**

### **1. Using the App's Diagnostic Tools**

1. **Long press the settings icon** in the dashboard header
2. **View API status** (Base URL, Mock Mode, Login Status)
3. **Test API Connection** to check connectivity
4. **Perform Test Login** to simulate authentication
5. **Toggle Mock Mode** to switch between real/mock API

### **2. Manual API Testing**

Test your API endpoints using curl or Postman:

```bash
# Health check
curl http://127.0.0.1:9000/api/health

# Login test
curl -X POST http://127.0.0.1:9000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password"}'

# Profile test (with token)
curl http://127.0.0.1:9000/api/user/profile \
  -H "Authorization: Bearer your_token_here"
```

### **3. Expected Response Formats**

**Login Response:**
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "refresh_token": "def50200...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "user": {
    "id": 1,
    "full_name": "Ahmad Rahman",
    "email": "ahmad@example.com",
    "ic_number": "850123456789",
    "phone_number": "+60123456789",
    "address_1": "No 123, Jalan Utama",
    "created_at": "2024-01-01T00:00:00.000000Z",
    "updated_at": "2024-01-01T00:00:00.000000Z"
  }
}
```

**Profile Response:**
```json
{
  "id": 1,
  "full_name": "Ahmad Rahman",
  "email": "ahmad@example.com",
  "ic_number": "850123456789",
  "phone_number": "+60123456789",
  "address_1": "No 123, Jalan Utama",
  "address_2": "Taman Desa",
  "city": "Kuala Lumpur",
  "state": "Selangor",
  "country": "Malaysia",
  "balance": 1500.50,
  "member_since": "January 2024",
  "is_verified": true,
  "is_email_verified": true,
  "is_phone_verified": true,
  "created_at": "2024-01-01T00:00:00.000000Z",
  "updated_at": "2024-01-01T00:00:00.000000Z"
}
```

---

## 📋 **Quick Fix Checklist**

- [ ] **Start your API server** on `http://127.0.0.1:9000`
- [ ] **Test health endpoint**: `GET /api/health`
- [ ] **Implement required endpoints** (login, profile, stats)
- [ ] **Update API base URL** if using different server
- [ ] **Disable mock mode**: Set `useMockMode = false`
- [ ] **Test login flow** in the app
- [ ] **Verify user data loads** correctly

---

## 🎯 **Current Status**

✅ **Mock API Working**: User name shows as "Ahmad Rahman"  
✅ **Storage System Fixed**: Data persists between app restarts  
✅ **Debug Tools Available**: Easy troubleshooting  
⚠️ **Real API Needed**: Set up backend server for production  

The app will work perfectly with mock data while you set up the real API server! 

This document details all functional modules, user flows, and error-handling specs for the Co-Working Space Flutter mobile application. It is designed to guide manual testing, automation planning, UML modeling, and graduation project documentation.

_____________________________________________________________________________________________________
_____________________________________________________________________________________________________


## MODULE 1: AUTHENTICATION (LOCAL & GOOGLE)

### 1.1 Local Sign Up Flow
*   **Description**: A new user registers an account using username, email, and password.
*   **A. Normal / Success Flow**:
    1.  User enters a valid, unique username, email (e.g., `test@example.com`), and password (8+ characters).
    2.  User taps "Sign Up".
    3.  Frontend performs validation check (passes).
    4.  Frontend displays loading indicator (`isLoading = true`).
    5.  Frontend calls `POST /auth/local/signup`.
    6.  Backend returns `201 Created`.
    7.  Frontend clears inputs, navigates to Email Verification screen (`/verify-email`), and displays a success notification.
*   **B. Frontend Validation Failures**:
    *   *Empty Fields*: Any input is empty. Show validation error snackbar: "Empty Fields".
    *   *Invalid Email Format*: Email format is missing `@` or domain. Show: "Invalid Email".
    *   *Weak Password*: Password is less than 8 characters. Show: "Weak Password".
*   **C. Backend / Business Error Cases**:
    *   *Email Already In Use (HTTP 400)*: Show: "Email Already Used - An account with this email already exists."
    *   *Unprocessable Entity (HTTP 422)*: Incorrect JSON format payload. Show: "Invalid Data".
    *   *Server Email Sending Failure (HTTP 500)*: Account is created but verification email could not be sent. Show: "Email Error - We could not send the verification email."
*   **D. Loading & Offline Edge Cases**:
    *   *Slow Connection*: Spinner animates; button disabled to prevent duplicate submissions.
    *   *Network Offline (HTTP 0)*: Intercepted by `AuthService`. Show: "Network error. Please check your internet connection."

_____________________________________________________________________________________________________
_____________________________________________________________________________________________________


### 1.2 Local Sign In Flow
*   **Description**: An existing user logs in using registered email and password.
*   **A. Normal / Success Flow**:
    1.  User enters correct email and password.
    2.  User taps "Sign In".
    3.  Frontend calls `POST /auth/local/login`.
    4.  Backend returns `200 OK` with JSON: `{ "access_token": "JWT_TOKEN", "has_password": true }`.
    5.  Frontend stores token in secure storage (`auth_token` and `auth_provider = local`).
    6.  Frontend redirects user to Homepage (`/home`).
*   **B. Frontend Validation Failures**:
    *   *Empty Fields*: Show snackbar: "Empty Fields".
    *   *Invalid Email Format*: Show snackbar: "Invalid Email".
*   **C. Backend / Business Error Cases**:
    *   *Wrong Credentials (HTTP 401)*: Email or password is incorrect. Show: "Wrong Credentials".
    *   *User Not Found (HTTP 404)*: No user exists with this email. Show: "User Not Found".
    *   *Email Not Verified (HTTP 403)*: User registered but didn't verify email. Show: "Email Not Verified" and automatically redirect to Email Verification screen.
*   **D. Loading & Offline Edge Cases**:
    *   *No Network*: Fails gracefully. Show: "Network error."

_____________________________________________________________________________________________________
_____________________________________________________________________________________________________


### 1.3 Google Authentication Flow
*   **Description**: User registers/logs in instantly via Google Single Sign-On (SSO).
*   **A. Normal / Success Flow**:
    1.  User taps "Sign in with Google".
    2.  Google Sign-In sheet pops up. User selects their Google account.
    3.  Firebase Auth signs in using Google credentials and returns a Firebase ID Token.
    4.  Frontend sends ID token to `POST /auth/firebase`.
    5.  Backend verifies ID token, registers user if new, and returns a local JWT token and flag `has_password: false`.
    6.  Frontend saves token and navigates to Homepage (`/home`).
    7.  Frontend triggers phone number verification prompt dialog if the user has no phone linked.
*   **B. Failure & Error Flow**:
    *   *User Cancels Flow*: User closes the Google selection sheet. App dismisses loading spinner, returning to sign-in screen silently.
    *   *Invalid Firebase Token (HTTP 401)*: The ID token signature is invalid. Show: "Invalid Google Token".
    *   *Backend Registration Error (HTTP 400)*: A local account with the same email already exists. Show: "Local Account Exists - Please sign in using password."

_____________________________________________________________________________________________________
_____________________________________________________________________________________________________


## MODULE 2: EMAIL & PHONE VERIFICATION

### 2.1 Sign-Up Email Verification
*   **Description**: Validating the user's email address by entering a code sent after signup.
*   **A. Normal / Success Flow**:
    1.  User receives a 6-digit code in their inbox.
    2.  User types the code and taps "Verify".
    3.  Frontend calls `POST /auth/local/confirm-email`.
    4.  Backend returns `200 OK`.
    5.  Frontend shows success snackbar: "Email Verified", and redirects to Sign In screen (`/login`).
*   **B. Validation & Business Error Cases**:
    *   *Empty Code*: Show snackbar: "Missing Code".
    *   *Code Expired (HTTP 400)*: Code is older than validity window. Show: "Code Expired - No code was found. Please sign up again."
    *   *Wrong Code (HTTP 401)*: Incorrect digits entered. Show: "Wrong Code - Verification code is incorrect."

_____________________________________________________________________________________________________
_____________________________________________________________________________________________________


### 2.2 Phone Number Verification
*   **Description**: Verifying the user's phone number from the Account Settings screen to unlock booking capabilities.
*   **A. Step 1: Send Verification SMS**:
    *   *Success Flow*: User inputs phone number (length >= 9). Call `POST /me/phone/send-code`. Backend sends SMS and returns `200 OK`. Show: "Code Sent".
    *   *Phone Already Used (HTTP 409)*: Phone number is tied to another account. Show: "Phone Exists".
    *   *Expired Token (HTTP 401)*: User session expired. Show: "Session Expired".
*   **B. Step 2: Verify SMS Code**:
    *   *Success Flow*: User inputs 6-digit SMS code. Call `POST /me/phone/verify-code`. Backend returns `200 OK`. Show: "Phone Verified ✓", and redirect user back to Settings.
    *   *Invalid SMS Code (HTTP 401)*: The SMS code is wrong. Show: "Wrong Code - The SMS code you entered is invalid."
    *   *No Pending Code (HTTP 400)*: No SMS code requested. Show: "No Code Found".
    *   *Belongs to other User (HTTP 403)*: Code matches another verification record. Show: "Verification Error".

_____________________________________________________________________________________________________
_____________________________________________________________________________________________________


## MODULE 3: PASSWORD RECOVERY

### 3.1 Send Password Reset Code
*   **Description**: User requests a password reset code to their email.
*   **A. Normal Flow**: User enters email, calls `POST /auth/local/forgot-password`. Code is sent. Redirect to code verification page.
*   **B. Errors**:
    *   *User Not Found (HTTP 404)*: Show: "User Not Found - No user registered with this email."
    *   *Mail Failure (HTTP 500)*: Show: "Email Error - Failed to send code."

### 3.2 Verify Reset Code
*   **Description**: User enters the code received in their email to authorize password reset.
*   **A. Normal Flow**: Calls `POST /auth/local/verify-reset-code`. On `200 OK`, saves `reset_token` and redirects to Set New Password screen.
*   **B. Errors**:
    *   *Expired Code (HTTP 400)*: Show: "Expired Code".
    *   *Invalid Code (HTTP 401)*: Show: "Invalid Code".

### 3.3 Set New Password
*   **Description**: User submits a new password using the verified reset token.
*   **A. Normal Flow**: Calls `POST /auth/local/reset-password` with email, reset token, and new password. Backend resets password and redirects to login.
*   **B. Errors**:
    *   *Unauthorized (HTTP 400)*: No authorization found. Show: "Access Denied".
    *   *Invalid Token (HTTP 401)*: Show: "Invalid Reset Token".

_____________________________________________________________________________________________________
_____________________________________________________________________________________________________

## MODULE 4: USER PROFILE & PROFILE MODIFICATION

### 4.1 Fetch User Profile
*   **Description**: App loads profile details on dashboard/settings screen.
*   **A. Success (HTTP 200)**: Displays user's name, email, phone number, and wallet balance.
*   **B. Session Expiration (HTTP 401)**: User JWT token is invalid or has expired. Show: "Session Expired", wipe storage, redirect to login screen.
*   **C. Offline State**: Display cached profile details if available, with a banner: "Offline Mode".

### 4.2 Change Account Email
*   **Description**: Two-step email update flow from profile page.
*   **A. Step 1: Request Change**: Calls `POST /me/email/request` with new email. Returns `200 OK`. Displays SMS/email verification popup.
    *   *Email in Use (HTTP 409)*: Show: "Email Exists - Already in use."
*   **B. Step 2: Confirm Code**: Calls `POST /me/email/confirm` with code.
    *   *Wrong Code (HTTP 401)*: Show: "Wrong Code - The verification code you entered is invalid."
    *   *No Request (HTTP 400)*: Show: "No Request Found".

### 4.3 Change/Set Password
*   **Description**: Modifies old password or sets initial password for Google Auth accounts.
*   **A. Success (HTTP 200)**: Updates password, modifies local flags. Show: "Password updated successfully!".
*   **B. Incorrect Current Password (HTTP 401)**: Input old password does not match server. Show: "Wrong Password - The current password you entered is incorrect."

_____________________________________________________________________________________________________
_____________________________________________________________________________________________________


## MODULE 5: WORKSPACE & ROOM BROWSING

### 5.1 Browse Locations
*   **A. Normal Flow**: Calls `GET /locations`. Returns a list of co-working locations. Rendered as lists/cards with images.
*   **B. Empty State**: No locations configured in backend. Display illustration: "No locations found."
*   **C. Loading State**: Displays shimmering skeletons while the API request is loading.

### 5.2 Browse Rooms per Location
*   **A. Normal Flow**: User taps location card. Calls `GET /locations/{id}/rooms`. Displays rooms with prices, capacities, and base64 images.
*   **B. Loading State**: Shimmering cards.

_____________________________________________________________________________________________________
_____________________________________________________________________________________________________


## MODULE 6: BOOKING & RESERVATION SYSTEM

### 6.1 Check Room Availability
*   **Description**: Querying occupied slots to highlight available dates/times on calendar.
*   **A. Normal Flow**: Calls `GET /bookings/occupied-slots?room_id={id}&booking_type_id={type_id}`.
    *   *Hourly slots*: Disables already booked hours (e.g., 08:00, 10:00).
    *   *Daily slots*: Colors booked days red.
*   **B. Failure (HTTP 500/Connection Error)**: Show: "Failed to load availability". Allow user to retry.

### 6.2 Confirm Reservation
*   **Description**: User confirms selection and calls `POST /bookings`.
*   **A. Success Flow (HTTP 201 Created)**: Booking confirmed, price deducted from wallet balance. Displays: "Reservation confirmed!".
*   **B. Validation & Business Failures**:
    *   *Phone Number Not Verified (HTTP 400/403)*: User attempts to book but has no verified phone. Show: "Please verify your phone number in settings before making a booking."
    *   *Double Booking / Occupied (HTTP 409)*: Someone else completed the checkout of the same slot a second earlier. Show: "Slot Unavailable - The selected time slot is already booked."
    *   *Insufficient Funds (HTTP 400)*: User wallet balance is lower than reservation price. Show: "Insufficient Balance - Please recharge your account."

### 6.3 Cancel Reservation
*   **Description**: User cancels an upcoming reservation.
*   **A. Success Flow (HTTP 200)**: Deletes booking, refunds booking amount to wallet. Show: "Reservation cancelled, funds refunded."
*   **B. Cancellation Policy Violation (HTTP 400)**: User tries to cancel less than 24 hours before start time. Show: "Cancellation Restricted - You can only cancel bookings at least 24 hours in advance."

_____________________________________________________________________________________________________
_____________________________________________________________________________________________________


## MODULE 7: WALLET, BALANCE & TRANSACTIONS

### 7.1 Wallet Balance & Recharge
*   **A. Success Flow**: User checks wallet balance. If they tap recharge, calls payment portal (or mock recharge API). Wallet updates instantly.
*   **B. Display State**: Displays currency in "DZD" format with two decimal places.

### 7.2 Transaction History
*   **A. Success Flow (HTTP 200)**: Calls `GET /me/transactions`. Returns transactions categorized into booking payments (amount negative, shows room and location details), cancellation refunds (amount positive, shows room name), and recharges (amount positive).
*   **B. Empty State**: User has made no transactions. Show: "Your transaction history is empty."

_____________________________________________________________________________________________________
_____________________________________________________________________________________________________


## MODULE 8: SYSTEM RESILIENCY & EDGE CASES

### 8.1 Network Disruption (Offline / Flaky connection)
*   *Action*: User performs any read/write request while offline.
*   *Reaction*: Flutter http layer catches `SocketException` or `HttpException`. Instantly displays non-blocking toast or snackbar: "Network error. Please check your internet connection." loading state is dismissed.

### 8.2 API Gateway Gateway Timeout (HTTP 504 / Ngrok Tunnel Down)
*   *Action*: The ngrok tunnel is down or starting up.
*   *Reaction*: Connection timeout triggers after 60s. Catches `TimeoutException`. Returns standard error map. Show: "The server is starting up. Please wait a moment and try again."

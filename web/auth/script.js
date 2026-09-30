document.addEventListener('DOMContentLoaded', () => {

  // --- ELEMENT REFERENCES ---
  const authCard = document.getElementById('authCard');
  const dashboardView = document.getElementById('dashboardView');
  const tabSignin = document.getElementById('tabSignin');
  const tabRegister = document.getElementById('tabRegister');
  const signinForm = document.getElementById('signinForm');
  const registerForm = document.getElementById('registerForm');

  // Sign In Elements
  const signinAccount = document.getElementById('signinAccount');
  const signinAccountError = document.getElementById('signinAccountError');
  const signinPassword = document.getElementById('signinPassword');
  const signinPasswordError = document.getElementById('signinPasswordError');
  const toggleSigninPassword = document.getElementById('toggleSigninPassword');

  // Register Elements
  const registerAccount = document.getElementById('registerAccount');
  const registerAccountError = document.getElementById('registerAccountError');
  const sendOtpBtn = document.getElementById('sendOtpBtn');
  const otpGroup = document.getElementById('otpGroup');
  const registerOtp = document.getElementById('registerOtp');
  const registerOtpError = document.getElementById('registerOtpError');
  const timerCountdown = document.getElementById('timerCountdown');
  const registerPassword = document.getElementById('registerPassword');
  const registerPasswordError = document.getElementById('registerPasswordError');
  const toggleRegisterPassword = document.getElementById('toggleRegisterPassword');
  const registerConfirmPassword = document.getElementById('registerConfirmPassword');
  const registerConfirmPasswordError = document.getElementById('registerConfirmPasswordError');
  const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');

  // Dashboard & Modal Elements
  const dashboardUsername = document.getElementById('dashboardUsername');
  const dashboardAccount = document.getElementById('dashboardAccount');
  const userAvatar = document.getElementById('userAvatar');
  const logoutTriggerBtn = document.getElementById('logoutTriggerBtn');
  const logoutModal = document.getElementById('logoutModal');
  const cancelLogoutBtn = document.getElementById('cancelLogoutBtn');
  const confirmLogoutBtn = document.getElementById('confirmLogoutBtn');
  const closeModalCross = document.getElementById('closeModalCross');

  // --- REGEX PATTERNS ---
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  const mobileRegex = /^(\+?\d{1,3}[- ]?)?\d{10,11}$/;
  // Password requirement: min 8 chars, 1 upper, 1 lower, 1 number, 1 special (@$!%*?&)
  const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

  let otpTimerInterval = null;
  let isOtpSent = false;

  // --- TAB SWITCHING ---
  tabSignin.addEventListener('click', () => {
    tabSignin.classList.add('active');
    tabRegister.classList.remove('active');
    signinForm.classList.add('active');
    registerForm.classList.remove('active');
    resetForm(registerForm);
  });

  tabRegister.addEventListener('click', () => {
    tabRegister.classList.add('active');
    tabSignin.classList.remove('active');
    registerForm.classList.add('active');
    signinForm.classList.remove('active');
    resetForm(signinForm);
  });

  // --- SHOW/HIDE PASSWORD EYE TOGGLE ---
  function setupPasswordToggle(inputEl, toggleBtn) {
    toggleBtn.addEventListener('click', () => {
      const isPassword = inputEl.type === 'password';
      inputEl.type = isPassword ? 'text' : 'password';

      const eyeOffLine = toggleBtn.querySelector('.eye-off');
      if (isPassword) {
        eyeOffLine.classList.remove('hidden');
      } else {
        eyeOffLine.classList.add('hidden');
      }
    });
  }

  setupPasswordToggle(signinPassword, toggleSigninPassword);
  setupPasswordToggle(registerPassword, toggleRegisterPassword);
  setupPasswordToggle(registerConfirmPassword, toggleConfirmPassword);

  // --- VALIDATION FUNCTIONS ---
  function validateAccount(inputEl, errorEl) {
    const value = inputEl.value.trim();
    if (!value) {
      return showError(inputEl, errorEl, 'Email or Mobile Number is required.');
    }
    const isEmail = emailRegex.test(value);
    const isMobile = mobileRegex.test(value.replace(/[\s-]/g, ''));

    if (!isEmail && !isMobile) {
      return showError(inputEl, errorEl, 'Enter a valid email (e.g. user@domain.com) or mobile number.');
    }
    return showSuccess(inputEl, errorEl);
  }

  function validatePassword(inputEl, errorEl) {
    const value = inputEl.value;
    if (!value) {
      return showError(inputEl, errorEl, 'Password is required.');
    }
    if (value.length < 8) {
      return showError(inputEl, errorEl, 'Password must be at least 8 characters long.');
    }
    if (!passwordRegex.test(value)) {
      return showError(
        inputEl,
        errorEl,
        'Must contain 1 uppercase, 1 lowercase, 1 number, and 1 special character (@, $, !, %, *, ?, &).'
      );
    }
    return showSuccess(inputEl, errorEl);
  }

  function validateConfirmPassword(confirmEl, passwordEl, errorEl) {
    const confirmVal = confirmEl.value;
    if (!confirmVal) {
      return showError(confirmEl, errorEl, 'Please re-enter your password.');
    }
    if (confirmVal !== passwordEl.value) {
      return showError(confirmEl, errorEl, 'Passwords do not match.');
    }
    return showSuccess(confirmEl, errorEl);
  }

  function validateOtp(inputEl, errorEl) {
    if (!isOtpSent) return true; // Don't block if OTP process wasn't triggered yet
    const value = inputEl.value.trim();
    if (!value) {
      return showError(inputEl, errorEl, 'OTP code is required.');
    }
    if (!/^\d{6}$/.test(value)) {
      return showError(inputEl, errorEl, 'Enter the 6-digit OTP sent to your email/mobile.');
    }
    return showSuccess(inputEl, errorEl);
  }

  function showError(inputEl, errorEl, message) {
    inputEl.classList.remove('valid');
    inputEl.classList.add('invalid');
    errorEl.textContent = message;
    return false;
  }

  function showSuccess(inputEl, errorEl) {
    inputEl.classList.remove('invalid');
    inputEl.classList.add('valid');
    errorEl.textContent = '';
    return true;
  }

  function resetForm(form) {
    const inputs = form.querySelectorAll('input');
    const errors = form.querySelectorAll('.error-msg');
    inputs.forEach(input => {
      input.classList.remove('valid', 'invalid');
      input.value = '';
    });
    errors.forEach(err => err.textContent = '');

    // Reset OTP
    if (form === registerForm) {
      otpGroup.classList.add('hidden');
      sendOtpBtn.disabled = false;
      sendOtpBtn.textContent = 'Send OTP';
      clearInterval(otpTimerInterval);
      isOtpSent = false;
    }
  }

  // --- SEND OTP & COUNTDOWN TIMER SIMULATION ---
  sendOtpBtn.addEventListener('click', () => {
    const isAccountValid = validateAccount(registerAccount, registerAccountError);
    if (!isAccountValid) return;

    // Show OTP field
    otpGroup.classList.remove('hidden');
    isOtpSent = true;
    registerOtp.focus();

    // Start 60s Timer Countdown
    let secondsLeft = 60;
    sendOtpBtn.disabled = true;
    sendOtpBtn.textContent = 'Sent ✓';
    timerCountdown.textContent = secondsLeft;

    clearInterval(otpTimerInterval);
    otpTimerInterval = setInterval(() => {
      secondsLeft--;
      timerCountdown.textContent = secondsLeft;

      if (secondsLeft <= 0) {
        clearInterval(otpTimerInterval);
        sendOtpBtn.disabled = false;
        sendOtpBtn.textContent = 'Resend OTP';
      }
    }, 1000);
  });

  // --- BLUR & INPUT LISTENERS ---
  signinAccount.addEventListener('blur', () => validateAccount(signinAccount, signinAccountError));
  signinPassword.addEventListener('blur', () => validatePassword(signinPassword, signinPasswordError));

  registerAccount.addEventListener('blur', () => validateAccount(registerAccount, registerAccountError));
  registerOtp.addEventListener('blur', () => validateOtp(registerOtp, registerOtpError));
  registerPassword.addEventListener('blur', () => {
    validatePassword(registerPassword, registerPasswordError);
    if (registerConfirmPassword.value) {
      validateConfirmPassword(registerConfirmPassword, registerPassword, registerConfirmPasswordError);
    }
  });
  registerConfirmPassword.addEventListener('blur', () => {
    validateConfirmPassword(registerConfirmPassword, registerPassword, registerConfirmPasswordError);
  });

  // Clear errors dynamically on input
  [signinAccount, signinPassword, registerAccount, registerOtp, registerPassword, registerConfirmPassword].forEach(input => {
    input.addEventListener('input', () => {
      if (input.classList.contains('invalid')) {
        input.classList.remove('invalid');
      }
    });
  });

  // --- FORM SUBMISSION ---
  signinForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const isAccValid = validateAccount(signinAccount, signinAccountError);
    const isPassValid = validatePassword(signinPassword, signinPasswordError);

    if (isAccValid && isPassValid) {
      loginUser(signinAccount.value.trim());
    }
  });

  registerForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const isAccValid = validateAccount(registerAccount, registerAccountError);
    const isOtpValid = validateOtp(registerOtp, registerOtpError);
    const isPassValid = validatePassword(registerPassword, registerPasswordError);
    const isConfirmValid = validateConfirmPassword(registerConfirmPassword, registerPassword, registerConfirmPasswordError);

    if (!isOtpSent) {
      validateAccount(registerAccount, registerAccountError);
      showError(registerAccount, registerAccountError, 'Please click "Send OTP" to verify your account.');
      return;
    }

    if (isAccValid && isOtpValid && isPassValid && isConfirmValid) {
      loginUser(registerAccount.value.trim());
    }
  });

  // --- LOGIN & DASHBOARD STATE ---
  function loginUser(account) {
    dashboardAccount.textContent = account;
    const namePart = account.split('@')[0];
    dashboardUsername.textContent = `Welcome, ${namePart.charAt(0).toUpperCase() + namePart.slice(1)}`;
    userAvatar.textContent = namePart.charAt(0).toUpperCase();

    authCard.classList.add('hidden');
    dashboardView.classList.remove('hidden');
  }

  // --- LOG OUT CONFIRMATION MODAL POPUP LOGIC ---
  function openLogoutModal() {
    logoutModal.classList.add('active');
    logoutModal.setAttribute('aria-hidden', 'false');
    cancelLogoutBtn.focus();
  }

  function closeLogoutModal() {
    logoutModal.classList.remove('active');
    logoutModal.setAttribute('aria-hidden', 'true');
  }

  function performLogout() {
    closeLogoutModal();
    dashboardView.classList.add('hidden');
    authCard.classList.remove('hidden');

    resetForm(signinForm);
    resetForm(registerForm);
    tabSignin.click();
  }

  logoutTriggerBtn.addEventListener('click', openLogoutModal);
  cancelLogoutBtn.addEventListener('click', closeLogoutModal);
  closeModalCross.addEventListener('click', closeLogoutModal);

  logoutModal.addEventListener('click', (e) => {
    if (e.target === logoutModal) {
      closeLogoutModal();
    }
  });

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && logoutModal.classList.contains('active')) {
      closeLogoutModal();
    }
  });

});

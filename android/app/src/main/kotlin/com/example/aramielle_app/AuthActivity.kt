package com.example.aramielle_app

import android.app.Dialog
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.os.CountDownTimer
import android.util.Patterns
import android.view.View
import android.view.Window
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.button.MaterialButton
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import java.util.regex.Pattern

class AuthActivity : AppCompatActivity() {

    // Views
    private lateinit var btnTabSignin: MaterialButton
    private lateinit var btnTabRegister: MaterialButton
    private lateinit var layoutSigninForm: LinearLayout
    private lateinit var layoutRegisterForm: LinearLayout
    private lateinit var layoutDashboardView: LinearLayout

    // Sign In Views
    private lateinit var tilSigninAccount: TextInputLayout
    private lateinit var etSigninAccount: TextInputEditText
    private lateinit var tilSigninPassword: TextInputLayout
    private lateinit var etSigninPassword: TextInputEditText
    private lateinit var btnSigninSubmit: MaterialButton

    // Register Views
    private lateinit var tilRegisterAccount: TextInputLayout
    private lateinit var etRegisterAccount: TextInputEditText
    private lateinit var btnSendOtp: MaterialButton
    private lateinit var layoutOtpGroup: LinearLayout
    private lateinit var tilRegisterOtp: TextInputLayout
    private lateinit var etRegisterOtp: TextInputEditText
    private lateinit var tvOtpTimer: TextView
    private lateinit var tilRegisterPassword: TextInputLayout
    private lateinit var etRegisterPassword: TextInputEditText
    private lateinit var tilRegisterConfirmPassword: TextInputLayout
    private lateinit var etRegisterConfirmPassword: TextInputEditText
    private lateinit var btnRegisterSubmit: MaterialButton

    // Dashboard Views
    private lateinit var tvWelcomeUser: TextView
    private lateinit var tvUserAccount: TextView
    private lateinit var btnLogoutTrigger: MaterialButton

    // State & Timer
    private var otpTimer: CountDownTimer? = null
    private var isOtpSent = false

    // Password pattern: min 8 chars, 1 upper, 1 lower, 1 digit, 1 special char
    private val passwordPattern: Pattern = Pattern.compile(
        "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_auth)

        initViews()
        setupListeners()
    }

    private fun initViews() {
        btnTabSignin = findViewById(R.id.btnTabSignin)
        btnTabRegister = findViewById(R.id.btnTabRegister)
        layoutSigninForm = findViewById(R.id.layoutSigninForm)
        layoutRegisterForm = findViewById(R.id.layoutRegisterForm)
        layoutDashboardView = findViewById(R.id.layoutDashboardView)

        // Sign In
        tilSigninAccount = findViewById(R.id.tilSigninAccount)
        etSigninAccount = findViewById(R.id.etSigninAccount)
        tilSigninPassword = findViewById(R.id.tilSigninPassword)
        etSigninPassword = findViewById(R.id.etSigninPassword)
        btnSigninSubmit = findViewById(R.id.btnSigninSubmit)

        // Register
        tilRegisterAccount = findViewById(R.id.tilRegisterAccount)
        etRegisterAccount = findViewById(R.id.etRegisterAccount)
        btnSendOtp = findViewById(R.id.btnSendOtp)
        layoutOtpGroup = findViewById(R.id.layoutOtpGroup)
        tilRegisterOtp = findViewById(R.id.tilRegisterOtp)
        etRegisterOtp = findViewById(R.id.etRegisterOtp)
        tvOtpTimer = findViewById(R.id.tvOtpTimer)
        tilRegisterPassword = findViewById(R.id.tilRegisterPassword)
        etRegisterPassword = findViewById(R.id.etRegisterPassword)
        tilRegisterConfirmPassword = findViewById(R.id.tilRegisterConfirmPassword)
        etRegisterConfirmPassword = findViewById(R.id.etRegisterConfirmPassword)
        btnRegisterSubmit = findViewById(R.id.btnRegisterSubmit)

        // Dashboard
        tvWelcomeUser = findViewById(R.id.tvWelcomeUser)
        tvUserAccount = findViewById(R.id.tvUserAccount)
        btnLogoutTrigger = findViewById(R.id.btnLogoutTrigger)
    }

    private fun setupListeners() {
        // Tab switching
        btnTabSignin.setOnClickListener { switchTab(isSignin = true) }
        btnTabRegister.setOnClickListener { switchTab(isSignin = false) }

        // Send OTP button
        btnSendOtp.setOnClickListener { handleSendOtp() }

        // Form submissions
        btnSigninSubmit.setOnClickListener { handleSigninSubmit() }
        btnRegisterSubmit.setOnClickListener { handleRegisterSubmit() }

        // Log Out confirmation dialog
        btnLogoutTrigger.setOnClickListener { showLogoutConfirmationDialog() }
    }

    private fun switchTab(isSignin: Boolean) {
        if (isSignin) {
            btnTabSignin.setBackgroundColor(Color.parseColor("#FFC900"))
            btnTabSignin.setTextColor(Color.parseColor("#111318"))
            btnTabRegister.setBackgroundColor(Color.TRANSPARENT)
            btnTabRegister.setTextColor(Color.parseColor("#A0A5B5"))

            layoutSigninForm.visibility = View.VISIBLE
            layoutRegisterForm.visibility = View.GONE
        } else {
            btnTabRegister.setBackgroundColor(Color.parseColor("#FFC900"))
            btnTabRegister.setTextColor(Color.parseColor("#111318"))
            btnTabSignin.setBackgroundColor(Color.TRANSPARENT)
            btnTabSignin.setTextColor(Color.parseColor("#A0A5B5"))

            layoutRegisterForm.visibility = View.VISIBLE
            layoutSigninForm.visibility = View.GONE
        }
    }

    private fun validateAccount(input: String): Boolean {
        if (input.isEmpty()) return false
        val isEmail = Patterns.EMAIL_ADDRESS.matcher(input).matches()
        val isPhone = input.replace("[\\s-]".toRegex(), "").matches(Regex("^(\\+?\\d{1,3})?\\d{10,11}$"))
        return isEmail || isPhone
    }

    private fun handleSendOtp() {
        val account = etRegisterAccount.text.toString().trim()
        if (!validateAccount(account)) {
            tilRegisterAccount.error = "Enter a valid email or mobile number"
            return
        }
        tilRegisterAccount.error = null

        // Reveal OTP Field & start 60s countdown
        layoutOtpGroup.visibility = View.VISIBLE
        isOtpSent = true
        btnSendOtp.isEnabled = false
        btnSendOtp.text = "Sent ✓"

        otpTimer?.cancel()
        otpTimer = object : CountDownTimer(60000, 1000) {
            override fun onTick(millisUntilFinished: Long) {
                val seconds = millisUntilFinished / 1000
                tvOtpTimer.text = "Resend in ${seconds}s"
            }

            override fun onFinish() {
                tvOtpTimer.text = "Resend available"
                btnSendOtp.isEnabled = true
                btnSendOtp.text = "Resend OTP"
            }
        }.start()

        Toast.makeText(this, "OTP sent to $account", Toast.LENGTH_SHORT).show()
    }

    private fun handleSigninSubmit() {
        val account = etSigninAccount.text.toString().trim()
        val password = etSigninPassword.text.toString()

        var isValid = true

        if (!validateAccount(account)) {
            tilSigninAccount.error = "Valid email or mobile number required"
            isValid = false
        } else {
            tilSigninAccount.error = null
        }

        if (password.isEmpty() || password.length < 8) {
            tilSigninPassword.error = "Password must be at least 8 characters"
            isValid = false
        } else {
            tilSigninPassword.error = null
        }

        if (isValid) {
            showDashboardSession(account)
        }
    }

    private fun handleRegisterSubmit() {
        val account = etRegisterAccount.text.toString().trim()
        val otp = etRegisterOtp.text.toString().trim()
        val password = etRegisterPassword.text.toString()
        val confirmPassword = etRegisterConfirmPassword.text.toString()

        var isValid = true

        if (!validateAccount(account)) {
            tilRegisterAccount.error = "Valid email or mobile number required"
            isValid = false
        } else {
            tilRegisterAccount.error = null
        }

        if (!isOtpSent) {
            tilRegisterAccount.error = "Click 'Send OTP' to verify your account"
            isValid = false
        }

        if (isOtpSent && (otp.isEmpty() || otp.length < 6)) {
            tilRegisterOtp.error = "6-digit OTP code required"
            isValid = false
        } else {
            tilRegisterOtp.error = null
        }

        if (!passwordPattern.matcher(password).matches()) {
            tilRegisterPassword.error = "Min 8 chars, 1 uppercase, 1 lowercase, 1 digit, 1 special (@$!%*?&)"
            isValid = false
        } else {
            tilRegisterPassword.error = null
        }

        if (confirmPassword.isEmpty() || confirmPassword != password) {
            tilRegisterConfirmPassword.error = "Passwords do not match"
            isValid = false
        } else {
            tilRegisterConfirmPassword.error = null
        }

        if (isValid) {
            showDashboardSession(account)
        }
    }

    private fun showDashboardSession(account: String) {
        val namePart = account.split("@")[0]
        tvWelcomeUser.text = "Welcome, ${namePart.replaceFirstChar { it.uppercase() }}"
        tvUserAccount.text = account

        layoutSigninForm.visibility = View.GONE
        layoutRegisterForm.visibility = View.GONE
        findViewById<View>(R.id.btnTabSignin).visibility = View.GONE
        findViewById<View>(R.id.btnTabRegister).visibility = View.GONE
        layoutDashboardView.visibility = View.VISIBLE
    }

    // Centered Custom Log Out Confirmation Dialog
    private fun showLogoutConfirmationDialog() {
        val dialog = Dialog(this)
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE)
        dialog.setContentView(R.layout.dialog_logout)
        dialog.window?.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        dialog.setCancelable(true)

        val btnCancel = dialog.findViewById<Button>(R.id.btnCancelLogout)
        val btnConfirm = dialog.findViewById<Button>(R.id.btnConfirmLogout)

        btnCancel.setOnClickListener {
          dialog.dismiss()
        }

        btnConfirm.setOnClickListener {
            dialog.dismiss()
            performLogout()
        }

        dialog.show()
    }

    private fun performLogout() {
        otpTimer?.cancel()
        isOtpSent = false

        layoutDashboardView.visibility = View.GONE
        findViewById<View>(R.id.btnTabSignin).visibility = View.VISIBLE
        findViewById<View>(R.id.btnTabRegister).visibility = View.VISIBLE
        
        switchTab(isSignin = true)
        Toast.makeText(this, "Logged out successfully", Toast.LENGTH_SHORT).show()
    }

    override fun onDestroy() {
        super.onDestroy()
        otpTimer?.cancel()
    }
}

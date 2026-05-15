package com.selfmaster.controller;

import com.selfmaster.dto.ApiResponse;
import com.selfmaster.dto.AuthDto;
import com.selfmaster.service.AuthService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * Authentication controller - handles both REST API and Thymeleaf page routes.
 */
@Controller
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    // ===== THYMELEAF PAGE ROUTES =====

    @GetMapping("/auth/login")
    public String loginPage(Model model) {
        model.addAttribute("loginRequest", new AuthDto.LoginRequest());
        return "auth/login";
    }

    @GetMapping("/auth/register")
    public String registerPage(Model model) {
        model.addAttribute("registerRequest", new AuthDto.RegisterRequest());
        return "auth/register";
    }

    @PostMapping("/auth/login")
    public String loginSubmit(@ModelAttribute AuthDto.LoginRequest loginRequest,
                              HttpServletResponse response, Model model) {
        try {
            AuthDto.AuthResponse authResponse = authService.login(loginRequest);
            addJwtCookie(response, authResponse.getToken());
            return "redirect:/dashboard";
        } catch (Exception e) {
            model.addAttribute("error", "Invalid credentials. Please try again.");
            model.addAttribute("loginRequest", loginRequest);
            return "auth/login";
        }
    }

    @PostMapping("/auth/register")
    public String registerSubmit(@ModelAttribute @Valid AuthDto.RegisterRequest registerRequest,
                                 HttpServletResponse response, Model model) {
        try {
            AuthDto.AuthResponse authResponse = authService.register(registerRequest);
            addJwtCookie(response, authResponse.getToken());
            return "redirect:/dashboard";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("registerRequest", registerRequest);
            return "auth/register";
        }
    }

    @GetMapping("/auth/logout")
    public String logout(HttpServletResponse response) {
        Cookie cookie = new Cookie("jwt_token", "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
        return "redirect:/auth/login?logout=true";
    }

    // ===== REST API ROUTES =====

    @PostMapping("/api/auth/register")
    @ResponseBody
    public ResponseEntity<ApiResponse<AuthDto.AuthResponse>> apiRegister(
            @RequestBody @Valid AuthDto.RegisterRequest request) {
        AuthDto.AuthResponse authResponse = authService.register(request);
        return ResponseEntity.ok(ApiResponse.success("Registration successful", authResponse));
    }

    @PostMapping("/api/auth/login")
    @ResponseBody
    public ResponseEntity<ApiResponse<AuthDto.AuthResponse>> apiLogin(
            @RequestBody @Valid AuthDto.LoginRequest request) {
        AuthDto.AuthResponse authResponse = authService.login(request);
        return ResponseEntity.ok(ApiResponse.success("Login successful", authResponse));
    }

    @PostMapping("/api/auth/forgot-password")
    @ResponseBody
    public ResponseEntity<ApiResponse<Void>> forgotPassword(
            @RequestBody AuthDto.PasswordResetRequest request) {
        authService.initiatePasswordReset(request.getEmail());
        return ResponseEntity.ok(ApiResponse.success("Password reset link sent to your email"));
    }

    @PostMapping("/api/auth/reset-password")
    @ResponseBody
    public ResponseEntity<ApiResponse<Void>> resetPassword(
            @RequestBody AuthDto.NewPasswordRequest request) {
        authService.resetPassword(request.getToken(), request.getNewPassword());
        return ResponseEntity.ok(ApiResponse.success("Password reset successful"));
    }

    private void addJwtCookie(HttpServletResponse response, String token) {
        Cookie cookie = new Cookie("jwt_token", token);
        cookie.setHttpOnly(true);
        cookie.setSecure(false); // Set true in production with HTTPS
        cookie.setPath("/");
        cookie.setMaxAge(86400); // 24 hours
        response.addCookie(cookie);
    }
}

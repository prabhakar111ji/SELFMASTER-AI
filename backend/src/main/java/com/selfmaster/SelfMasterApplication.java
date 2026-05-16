package com.selfmaster;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * SELFMASTER AI - Main Application Entry Point
 * 
 * An AI-Powered Behavioral Intelligence Platform
 * "Become the Master of Yourself."
 */
@SpringBootApplication
@EnableScheduling
@EnableAsync
public class SelfMasterApplication {

    public static void main(String[] args) {
        SpringApplication.run(SelfMasterApplication.class, args);
    }
}

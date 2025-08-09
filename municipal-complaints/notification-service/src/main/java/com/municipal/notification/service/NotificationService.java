package com.municipal.notification.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class NotificationService {
    private static final Logger log = LoggerFactory.getLogger(NotificationService.class);

    public void sendEmail(String to, String subject, String body) {
        log.info("Sending email to={} subject={} body={}", to, subject, body);
    }

    public void sendSms(String phone, String message) {
        log.info("Sending SMS to={} message={}", phone, message);
    }
}
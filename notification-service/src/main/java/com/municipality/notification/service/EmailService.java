package com.municipality.notification.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    public void sendComplaintStatusUpdate(String to, String complaintId, String status) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject("Complaint Status Update - #" + complaintId);
        message.setText("Dear Citizen,\n\n" +
                "Your complaint #" + complaintId + " status has been updated to: " + status + "\n\n" +
                "Thank you for using our complaint management system.\n\n" +
                "Best regards,\n" +
                "Municipality Administration");
        
        mailSender.send(message);
    }

    public void sendComplaintAssignment(String to, String complaintId, String department) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject("Complaint Assignment - #" + complaintId);
        message.setText("Dear Staff Member,\n\n" +
                "A new complaint #" + complaintId + " has been assigned to " + department + " department.\n\n" +
                "Please review and take appropriate action.\n\n" +
                "Best regards,\n" +
                "Municipality Administration");
        
        mailSender.send(message);
    }
}
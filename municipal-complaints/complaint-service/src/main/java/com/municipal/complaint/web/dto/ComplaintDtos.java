package com.municipal.complaint.web.dto;

import com.municipal.complaint.domain.Complaint;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class ComplaintDtos {

    public static class CreateComplaintRequest {
        @NotNull
        public Complaint.Category category;
        @NotBlank
        @Size(min = 10, max = 2000)
        public String description;
    }

    public static class UpdateStatusRequest {
        @NotNull
        public Complaint.Status status;
    }

    public static class AssignDepartmentRequest {
        @NotNull
        public Long departmentId;
    }

    public static class AddCommentRequest {
        @NotBlank
        @Size(min = 2, max = 2000)
        public String content;
    }
}
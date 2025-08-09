package com.municipality.complaint.service;

import com.municipality.complaint.dto.ComplaintCreateDto;
import com.municipality.complaint.dto.ComplaintResponseDto;
import com.municipality.complaint.dto.CommentDto;
import com.municipality.complaint.entity.ComplaintCategory;
import com.municipality.complaint.entity.ComplaintStatus;

import java.util.List;

public interface ComplaintService {
    ComplaintResponseDto createComplaint(ComplaintCreateDto createDto, Long citizenId);
    ComplaintResponseDto getComplaintById(Long id);
    List<ComplaintResponseDto> getAllComplaints();
    List<ComplaintResponseDto> getComplaintsByCitizen(Long citizenId);
    List<ComplaintResponseDto> getComplaintsByStatus(ComplaintStatus status);
    List<ComplaintResponseDto> getComplaintsByCategory(ComplaintCategory category);
    List<ComplaintResponseDto> getComplaintsByDepartment(String department);
    List<ComplaintResponseDto> getComplaintsByStaff(Long staffId);
    ComplaintResponseDto updateComplaintStatus(Long id, ComplaintStatus status);
    ComplaintResponseDto assignComplaintToDepartment(Long id, String department);
    ComplaintResponseDto assignComplaintToStaff(Long id, Long staffId);
    ComplaintResponseDto addComment(Long complaintId, CommentDto commentDto, Long authorId, String authorName, String authorRole);
    void deleteComplaint(Long id);
}
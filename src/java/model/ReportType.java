/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.ArrayList;

/**
 *
 * @author TuanPD
 */
public class ReportType {

    private int typeId;
    private String typeName;
    private ArrayList<Report> reportList;

    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public ArrayList<Report> getReportList() {
        return reportList;
    }

    public void setReportList(ArrayList<Report> reportList) {
        this.reportList = reportList;
    }

    
}

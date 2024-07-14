/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.text.ParseException;
import java.util.ArrayList;
import model.Slider;

/**
 *
 * @author HaiNV
 */
public class SliderContext extends ConnectionOpen {
    public ArrayList<Slider> getSliderList() throws SQLException, ParseException {
        String sql = "select slider\n"
                + "from Sliders\n"
                + "where current_timestamp between startDate and endDate;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ResultSet rs = ppsm.executeQuery();
        
        ArrayList<Slider> sliderList = new ArrayList<>();
        while(rs.next()) {
            sliderList.add(this.getSlider(
                    rs.getInt("slider")));
        }
        return sliderList;
    }
    
    public Slider getSlider(int sliderId) throws SQLException, ParseException {
        String sql = "select sliderTitle, sliderDescription, imagePath, backLink, startDate, endDate\n"
                + "from Sliders\n"
                + "where slider = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, sliderId);
        ResultSet rs = ppsm.executeQuery();
        
        Slider slider = new Slider();
        while (rs.next()) {
            slider.setId(sliderId);
            slider.setTitle(rs.getString("sliderTitle"));
            slider.setDescription(rs.getString("sliderDescription"));
            slider.setImagePath(rs.getString("imagePath"));
            slider.setBackLink(rs.getString("backLink"));
            slider.setStartDate(
                dateTime.parse(rs.getString("startDate")));
            slider.setEndDate(
                dateTime.parse(rs.getString("endDate")));
        }
        return slider;
    }
    
    
}

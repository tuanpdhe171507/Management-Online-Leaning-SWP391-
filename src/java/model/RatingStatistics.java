/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.text.DecimalFormat;

/**
 *
 * @author HaiNV
 */
public class RatingStatistics {
   private double averageRating;
    private int[] starCounts;
    private double[] starPercentages;
    private DecimalFormat df = new DecimalFormat("#.#");

    public RatingStatistics(double averageRating, int[] starCounts, double[] starPercentages) {
        this.averageRating = averageRating;
        this.starCounts = starCounts;
        this.starPercentages = starPercentages;
    }

    public double getAverageRating() {
        return averageRating;
    }

    public int[] getStarCounts() {
        return starCounts;
    }

    public double[] getStarPercentages() {
        return starPercentages;
    }

    public String[] getFormattedStarPercentages() {
        String[] formattedPercentages = new String[starPercentages.length];
        for (int i = 0; i < starPercentages.length; i++) {
            formattedPercentages[i] = df.format(starPercentages[i]) + "%";
        }
        return formattedPercentages;
    }

    public String formatAverageRating() {
        return df.format(this.averageRating);
    } 
}

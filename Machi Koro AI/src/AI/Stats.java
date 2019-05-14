package AI;

import java.util.LinkedList;

public class Stats {
	public static double mean(LinkedList<Double> n) {
		double sum = (double) 0;
		for (Double d : n) sum += d;
		return sum / (double) n.size();
	}
	public static double stdev(LinkedList<Double> n) {
		double mean = mean(n);
		double sum = 0;
		for (Double d : n) sum += Math.pow((d - mean),2);
		return Math.sqrt(sum / (n.size()-1));
	}
	public static double ttest_onesample(double x,LinkedList<Double> n) {
		double mean = mean(n);
		double num = mean - x;
		double den = stdev(n) / Math.sqrt(n.size());
		return num / den;
	}
}

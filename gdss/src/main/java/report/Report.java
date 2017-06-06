package report;

import java.awt.Graphics2D;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.data.general.DefaultPieDataset;
import org.json.JSONArray;
import org.json.JSONObject;

import com.itextpdf.awt.DefaultFontMapper;
import com.itextpdf.text.Document;
import com.itextpdf.text.List;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfTemplate;
import com.itextpdf.text.pdf.PdfWriter;

import converter.ResultSetConverter;
import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRField;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.export.SimpleExporterInput;
import net.sf.jasperreports.export.SimpleOutputStreamExporterOutput;
import net.sf.jasperreports.export.SimplePdfExporterConfiguration;
import net.sf.jasperreports.renderers.JCommonDrawableRenderer;

public class Report extends HttpServlet {

	private static final long serialVersionUID = 1L;
	DataSource pool;

	@Override
	public void init() throws ServletException {
		try {
			// Create a JNDI Initial context to be able to lookup the DataSource
			InitialContext ctx = new InitialContext();
			// Lookup the DataSource, which will be backed by a pool
			// that the application server provides.
			pool = (DataSource) ctx.lookup("java:comp/env/jdbc/gdss");
			if (pool == null)
				throw new ServletException("Unknown DataSource 'jdbc/gdss'");
		} catch (NamingException ex) {
			ex.printStackTrace();
		}
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

		response.setContentType("application/pdf");
		OutputStream outputStream = response.getOutputStream();
		int id = Integer.parseInt(request.getParameter("id"));
		JFreeChart chart = null;
		try {
			chart = getChart(id);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		int width = 405;
		int height = 410;
		if (((String) request.getParameter("action")).equals("download")) {
			InputStream template = new FileInputStream(getServletContext().getRealPath("view/report.jrxml"));
			JasperReport report = null;
			try {
				report = JasperCompileManager.compileReport(template);
			} catch (JRException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			JSONArray discussionData = null;
			try {
				discussionData = getDiscussionData(id);
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			ChartBean cb = new ChartBean(writeChartToPDF(chart, 500, 500, "Report"),
					discussionData.getJSONObject(0).getString("dis_title"),discussionData.getJSONObject(0).getString("dis_descreption"));
			ArrayList charts = new ArrayList();
			charts.add(cb);

			JasperPrint print = null;
			try {
				Map parameters = new HashMap();
				print = JasperFillManager.fillReport(report, parameters, new JRBeanCollectionDataSource(charts));
			} catch (JRException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				JRPdfExporter exporter = new JRPdfExporter();
				exporter.setExporterInput(new SimpleExporterInput(print));
				exporter.setExporterOutput(new SimpleOutputStreamExporterOutput(outputStream));
				SimplePdfExporterConfiguration configuration = new SimplePdfExporterConfiguration();
				configuration.setMetadataAuthor("SUSHIL");
				exporter.setConfiguration(configuration);
				exporter.exportReport();
			} catch (JRException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else
			ChartUtilities.writeChartAsPNG(outputStream, chart, width, height);
	}

	public class ChartBean {

		public ChartBean(BufferedImage image, String title,String description) {
			setImage(image);
			setTitle(title);
			setDescription(description);
		}

		private java.awt.image.BufferedImage image;
		private String title;
		private String description;

		public BufferedImage getImage() {
			return image;
		}

		public void setImage(BufferedImage image) {
			this.image = image;
		}

		public void setTitle(String title) {
			this.title = title;
		}
		
		public String getTitle() {
			return title;
		}
		
		public void setDescription(String description) {
			this.description = description;
		}
		
		public String getDescription() {
			return description;
		}

	}

	public JSONArray getDiscussionData(int id) throws SQLException {
		Connection conn = pool.getConnection();
		Statement stmt = conn.createStatement();
		String query = "Select * from tbl_discussion where dis_id = '" + id + "'";
		ResultSet result = stmt.executeQuery(query);
		JSONArray returnResult = ResultSetConverter.convert(result);
		stmt.close();
		conn.close();

		return returnResult;
	}

	public JFreeChart getChart(int id) throws SQLException {

		JSONArray returnResult = countVote(id);
		DefaultPieDataset dataset = new DefaultPieDataset();
		if (returnResult.length() > 0) {
			int totalCount = 0;
			for (int i = 0; i < returnResult.length(); i++) {
				JSONObject rec = returnResult.getJSONObject(i);
				totalCount = totalCount + rec.getInt("voteCount");
			}
			for (int i = 0; i < returnResult.length(); i++) {
				JSONObject rec = returnResult.getJSONObject(i);
				if (rec.getInt("vote_type") == 1) {
					dataset.setValue("like", rec.getInt("voteCount"));
				} else if (rec.getInt("vote_type") == 2) {
					dataset.setValue("Moderate Like", rec.getInt("voteCount"));
				} else if (rec.getInt("vote_type") == 3) {
					dataset.setValue("Moderate Dislike", rec.getInt("voteCount"));
				} else if (rec.getInt("vote_type") == 4) {
					dataset.setValue("Disike", rec.getInt("voteCount"));
				}
			}
		} else
			dataset.setValue("No Report Yet", 1);
		boolean legend = true;
		boolean tooltips = false;
		boolean urls = false;

		JFreeChart chart = ChartFactory.createPieChart("Report", dataset, legend, tooltips, urls);
		chart.setBorderVisible(true);

		return chart;
	}

	public JSONArray countVote(int id) throws SQLException {
		Connection conn = pool.getConnection();
		Statement stmt = conn.createStatement();
		String query = "Select count(id) as voteCount,vote_type from tbl_vote where dis_id = '" + id
				+ "' group by vote_type";
		ResultSet result = stmt.executeQuery(query);
		JSONArray returnResult = ResultSetConverter.convert(result);
		stmt.close();
		conn.close();

		return returnResult;

	}

	public BufferedImage writeChartToPDF(JFreeChart chart, int width, int height, String fileName) throws IOException {

		BufferedImage img = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);

		Graphics2D g2 = img.createGraphics();
		chart.draw(g2, new Rectangle2D.Double(0, 0, width, height));

		g2.dispose();
		return img;
	}

}
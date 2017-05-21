package report;

import java.awt.Graphics2D;
import java.awt.geom.Rectangle2D;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

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
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfTemplate;
import com.itextpdf.text.pdf.PdfWriter;

import converter.ResultSetConverter;

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

		response.setContentType("image/png");
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
		if (((String) request.getParameter("action")).equals("download"))
			writeChartToPDF(chart, 500, 500, "Report", response);
		else
			ChartUtilities.writeChartAsPNG(outputStream, chart, width, height);
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
		}
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

	public static void writeChartToPDF(JFreeChart chart, int width, int height, String fileName,HttpServletResponse response) throws IOException {
		PdfWriter writer = null;

		Document document = new Document();
		try {
			response.setContentType("application/pdf");
			writer = PdfWriter.getInstance(document, response.getOutputStream());
			document.open();
			PdfContentByte contentByte = writer.getDirectContent();
			PdfTemplate template = contentByte.createTemplate(width, height);
			Graphics2D graphics2d = template.createGraphics(width, height, new DefaultFontMapper());
			Rectangle2D rectangle2d = new Rectangle2D.Double(0, 0, width, height);

			chart.draw(graphics2d, rectangle2d);

			graphics2d.dispose();
			contentByte.addTemplate(template, 0, 0);

		} catch (Exception e) {
			e.printStackTrace();
		}
		document.close();
	}

}
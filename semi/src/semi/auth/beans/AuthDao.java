package semi.auth.beans;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import semi.beans.JDBCUtils;

public class AuthDao {

	public List<AuthDto> list() throws Exception {

		Connection con = JDBCUtils.getConnection();

		String sql = "select * from auth order by auth_no desc";

		PreparedStatement ps = con.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();

		List<AuthDto> authList = new ArrayList<>();

		while (rs.next()) {
			AuthDto authDto = new AuthDto();
			authDto.setAuthNo(rs.getInt("auth_no"));
			authDto.setAuthChallengeNo(rs.getInt("auth_challengeNo"));
			authDto.setAuthWriter(rs.getInt("auth_writer"));
			authDto.setAuthCategoryType(rs.getInt("auth_categoryType"));
			authDto.setAuthTitle(rs.getString("auth_title"));
			authDto.setAuthContent(rs.getString("auth_content"));
			authDto.setAuthTimeLine(rs.getDate("auth_timeLine"));
			authDto.setAuthResult(rs.getString("auth_result"));
			authDto.setAuthReason(rs.getString("auth_reason"));

			authList.add(authDto);
		}

		return authList;

	}

	public AuthDto get(int authNo) throws Exception {

		Connection con = JDBCUtils.getConnection();

		String sql = "select * from auth where auth_no = ?";

		PreparedStatement ps = con.prepareStatement(sql);
		ps.setInt(1, authNo);
		ResultSet rs = ps.executeQuery();

		AuthDto authDto = new AuthDto();
		if (rs.next()) {

			authDto.setAuthNo(rs.getInt("auth_no"));
			authDto.setAuthChallengeNo(rs.getInt("auth_challengeNo"));
			authDto.setAuthWriter(rs.getInt("auth_writer"));
			authDto.setAuthCategoryType(rs.getInt("auth_categoryType"));
			authDto.setAuthTitle(rs.getString("auth_title"));
			authDto.setAuthContent(rs.getString("auth_content"));
			authDto.setAuthTimeLine(rs.getDate("auth_timeLine"));
			authDto.setAuthResult(rs.getString("auth_result"));
			authDto.setAuthReason(rs.getString("auth_reason"));
		}
		else {
			authDto = null;
		}

		return authDto;

	}

	//auth 시퀀스 번호를 생성하는 기능
	public int getSequence() throws Exception {
		Connection con = JDBCUtils.getConnection();
		
		String sql = "select auth_seq.nextval from dual";
		PreparedStatement ps = con.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		rs.next();
		int authNo = rs.getInt(1);
		
		con.close();
		return authNo;
	}
	
	//인증글 등록 기능
	public void insert(AuthDto authDto) throws Exception {
		Connection con = JDBCUtils.getConnection();
		
		String sql = "insert into auth values(?, ?, ?, ?, ?, ?, sysdate, 'N', '미정', ?, ?, ?, ?)";
		PreparedStatement ps = con.prepareStatement(sql);
		ps.setInt(1, authDto.getAuthNo());
		ps.setInt(2, authDto.getAuthChallengeNo());
		ps.setInt(3, authDto.getAuthWriter());
		ps.setInt(4, authDto.getAuthCategoryType());
		ps.setString(5, authDto.getAuthTitle());
		ps.setString(6, authDto.getAuthContent());
		ps.setString(7, authDto.getAuthUploadName());
		ps.setString(8, authDto.getAuthSaveName());
		ps.setString(9, authDto.getAuthContentType());
		ps.setLong(10, authDto.getAuthFileSize());
		ps.execute();
		
		con.close();
	}
		
	//단일 조회 : authNo
	public AuthDto getByAuthNo(int authNo) throws Exception{
		Connection con = JDBCUtils.getConnection();
		
		String sql = "select * from auth where auth_no = ?";
		PreparedStatement ps = con.prepareStatement(sql);
		ps.setInt(1, authNo);
		ResultSet rs = ps.executeQuery();
		
		AuthDto authDto;
		if(rs.next()) {
			authDto = new AuthDto();
			authDto.setAuthNo(rs.getInt("auth_no"));
			authDto.setAuthChallengeNo(rs.getInt("auth_challengeNo"));
			authDto.setAuthWriter(rs.getInt("auth_writer"));
			authDto.setAuthCategoryType(rs.getInt("auth_categoryType"));
			authDto.setAuthTitle(rs.getString("auth_title"));
			authDto.setAuthContent(rs.getString("auth_content"));
			authDto.setAuthTimeLine(rs.getDate("auth_timeLine"));
			authDto.setAuthResult(rs.getString("auth_result"));
			authDto.setAuthReason(rs.getString("auth_reason"));
			
			authDto.setAuthUploadName(rs.getString("auth_uploadName"));
			authDto.setAuthSaveName(rs.getString("auth_saveName"));
			authDto.setAuthContentType(rs.getString("auth_contentType"));
			authDto.setAuthFileSize(rs.getLong("auth_fileSize"));
	}
	
	else {
			authDto = null;
	}
	
		con.close();
		return authDto;
	}
	
	public boolean changeResult(AuthDto authDto) throws Exception {
		Connection con = JDBCUtils.getConnection();
		
		String sql = "update auth set auth_result=?, auth_reason=? where auth_no=?";
		PreparedStatement ps = con.prepareStatement(sql);
		
		ps.setString(1, authDto.getAuthResult());
		ps.setString(2, authDto.getAuthReason());
		ps.setInt(3, authDto.getAuthNo());
		
		int count = ps.executeUpdate();
		con.close();
		return count>0;
	}
	
	//인증글 삭제 기능
	public boolean delete(int authNo) throws Exception {
		Connection con = JDBCUtils.getConnection();
		
		String sql = "delete auth where auth_no = ?";
		PreparedStatement ps = con.prepareStatement(sql);
		
		ps.setInt(1, authNo);
		int count = ps.executeUpdate();
		
		con.close();
		return count > 0;
	}
	
	public List getNoByChallengeNo(int challengeNo) throws Exception {
		Connection con = JDBCUtils.getConnection();
		
		String sql = "select auth_no from auth where auth_challengeNo=?";
		PreparedStatement ps = con.prepareStatement(sql);
		ps.setInt(1, challengeNo);
		ResultSet rs = ps.executeQuery();
		
		List list = new ArrayList();
		while(rs.next()) {
			int authNo = rs.getInt("auth_no");
			list.add(authNo);
		}
		
		return list;
	}
	
	public List<AuthDto> listByChallenge(int challengeNo) throws Exception {

		Connection con = JDBCUtils.getConnection();

		String sql = "select * from auth where auth_challengeNo = ? order by auth_no desc";

		PreparedStatement ps = con.prepareStatement(sql);
		ps.setInt(1, challengeNo);
		ResultSet rs = ps.executeQuery();

		List<AuthDto> authList = new ArrayList<>();

		while (rs.next()) {
			AuthDto authDto = new AuthDto();
			authDto.setAuthNo(rs.getInt("auth_no"));
			authDto.setAuthChallengeNo(rs.getInt("auth_challengeNo"));
			authDto.setAuthWriter(rs.getInt("auth_writer"));
			authDto.setAuthCategoryType(rs.getInt("auth_categoryType"));
			authDto.setAuthTitle(rs.getString("auth_title"));
			authDto.setAuthContent(rs.getString("auth_content"));
			authDto.setAuthTimeLine(rs.getDate("auth_timeLine"));
			authDto.setAuthResult(rs.getString("auth_result"));
			authDto.setAuthReason(rs.getString("auth_reason"));
			
			authDto.setAuthUploadName(rs.getString("auth_uploadName"));
			authDto.setAuthSaveName(rs.getString("auth_saveName"));
			authDto.setAuthContentType(rs.getString("auth_contentType"));
			authDto.setAuthFileSize(rs.getLong("auth_fileSize"));

			authList.add(authDto);
		}

		return authList;

	}

}

/****** Object:  StoredProcedure [dbo].[sp_TimNhaChoKhachHang]    Script Date: 12/18/2020 3:28:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_TimNhaChoKhachHang]
	@loaiNha varchar(50) = NULL,
	@gia money = NULL,
	@loaiGia int = NULL, --1 la nho hon hoac bang, 2 la lon hon hoac bang
	@soLuongPhong  int = NULL,
	@duongNha varchar(50) = NULL,
	@quanNha varchar(50) = NULL,
	@tpNha varchar(50) = NULL,
	@khuVucNha varchar(50) = NULL,
	@idChiNhanh varchar(10) = NULL
	
as
begin
	declare @strQuery nvarchar(3900)
	declare @paraList nvarchar(500)
	set @paraList = '
			@gia money,
			@loaiGia int,
			@soLuongPhong int,
			@duongNha varchar(50),
			@quanNha varchar(50),
			@tpNha varchar(50),
			@khuVucNha varchar(50),
			@idChiNhanh varchar(10)'
	--Ket cac bang lai truoc va loc sau
	if(@loaiNha = 'Nha Ban')
	begin
		set @strQuery = N'select n.*, nb.GIABAN, nb.DIEUKIENCNHA
		from NHA n join NHABAN nb on n.IDNHA = nb.IDNHA
		where n.TINHTRANG != 1 and n.NGAYDANG < getdate() and (n.NGAYHETHANG is NULL or n.NGAYHETHANG > getdate())'
		if(@gia != N'')
			if(@loaiGia = 1)
				set @strQuery = @strQuery + ' and nb.GIABAN <= @gia'
			else
				set @strQuery = @strQuery + ' and nb.GIABAN >= @gia'
		if(@soLuongPhong != N'')
			set @strQuery = @strQuery + ' and n.SOLUONGNHA = @soLuongPhong'
		if(@duongNha != N'')
			set @strQuery = @strQuery + ' and n.DUONGNHA = @duongNha'
		if(@quanNha != N'')
			set @strQuery = @strQuery + ' and n.QUANNHA = @quanNha'
		if(@tpNha != N'')
			set @strQuery = @strQuery + ' and n.TPNHA = @tpNha'
		if(@khuVucNha != N'')
			set @strQuery = @strQuery + ' and n.KHUVUCNHA = @khuVucNha'
		if(@idChiNhanh != N'')
			set @strQuery = @strQuery + ' and n.IDCNHANH = @idChinhNhanh'
	end
	else if(@loaiNha = 'Nha Thue')
	begin
		set @strQuery = N'select n.*, nt.TIENTHUE
						from NHA n join NHATHUE nt on n.IDNHA = nt.IDNHA
						where n.TINHTRANG != 1 and n.NGAYDANG < getdate() and (n.NGAYHETHANG is NULL or n.NGAYHETHANG > getdate())'
		if(@gia != N'')
			if(@loaiGia = 1)
				set @strQuery = @strQuery + ' and nb.TIENTHUE <= @gia'
			else
				set @strQuery = @strQuery + ' and nb.TIENTHUE >= @gia'
		if(@soLuongPhong != N'')
			set @strQuery = @strQuery + ' and n.SOLUONGNHA = @soLuongPhong'
		if(@duongNha != N'')
			set @strQuery = @strQuery + ' and n.DUONGNHA = @duongNha'
		if(@quanNha != N'')
			set @strQuery = @strQuery + ' and n.QUANNHA = @quanNha'
		if(@tpNha != N'')
			set @strQuery = @strQuery + ' and n.TPNHA = @tpNha'
		if(@khuVucNha != N'')
			set @strQuery = @strQuery + ' and n.KHUVUCNHA = @khuVucNha'
		if(@idChiNhanh != N'')
			set @strQuery = @strQuery + ' and n.IDCNHANH = @idChinhNhanh'
	end
	else
	begin
		select * from NHA n
		where n.TINHTRANG != 1 and n.NGAYDANG < getdate() 
		and (n.NGAYHETHANG is NULL or n.NGAYHETHANG > getdate())
	end

	exec sp_executesql @strQuery,
		@paraList,
		@gia, --Doi so dua vao phai tuong ung voi paraList
		@loaiGia,
		@soLuongPhong,
		@duongNha,
		@quanNha,
		@tpNha,
		@khuVucNha,
		@idChiNhanh
end
GO
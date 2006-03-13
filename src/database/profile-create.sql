use [profile]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SquadMembership_Squads]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SquadMembership] DROP CONSTRAINT FK_SquadMembership_Squads
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_withdraw_team_aleg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[p_withdraw_team_aleg]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_change_team_ownership_aleg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[p_change_team_ownership_aleg]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_create_team_profile_aleg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[p_create_team_profile_aleg]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_deny_petitions_aleg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[p_deny_petitions_aleg]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_edit_team_member_status2_aleg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[p_edit_team_member_status2_aleg]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_get_player_teams_aleg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[p_get_player_teams_aleg]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_get_team_members_aleg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[p_get_team_members_aleg]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_grant_petitions_aleg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[p_grant_petitions_aleg]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_petition_team_aleg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[p_petition_team_aleg]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_edit_team_profile_aleg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[p_edit_team_profile_aleg]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_get_team_profile_aleg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[p_get_team_profile_aleg]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SquadMembership]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SquadMembership]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Squads]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Squads]
GO

CREATE TABLE [dbo].[Squads] (
	[SquadID] [int] IDENTITY (1, 1) NOT NULL ,
	[SquadName] [varchar] (30) NOT NULL ,
	[Description] [varchar] (510) NULL ,
	[URL] [varchar] (255) NULL ,
	[OwnerID] [int] NOT NULL ,
	[dt_created] [datetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[SquadMembership] (
	[SquadID] [int] NOT NULL ,
	[CharID] [int] NOT NULL ,
	[i_status] [int] NOT NULL ,
	[i_secondary_status] [int] NOT NULL ,
	[dt_granted] [datetime] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Squads] WITH NOCHECK ADD 
	CONSTRAINT [PK_Squads] PRIMARY KEY  CLUSTERED 
	(
		[SquadID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[SquadMembership] WITH NOCHECK ADD 
	CONSTRAINT [PK_SquadMembership] PRIMARY KEY  CLUSTERED 
	(
		[SquadID],
		[CharID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Squads] WITH NOCHECK ADD 
	CONSTRAINT [DF_Squads_dt_created] DEFAULT (getdate()) FOR [dt_created],
	CONSTRAINT [IX_Squads] UNIQUE  NONCLUSTERED 
	(
		[SquadName]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[SquadMembership] WITH NOCHECK ADD 
	CONSTRAINT [DF_SquadMembership_i_status] DEFAULT (0) FOR [i_status],
	CONSTRAINT [DF_SquadMembership_i_secondary_status] DEFAULT (0) FOR [i_secondary_status],
	CONSTRAINT [DF_SquadMembership_dt_granted] DEFAULT (getdate()) FOR [dt_granted]
GO

ALTER TABLE [dbo].[SquadMembership] ADD 
	CONSTRAINT [FK_SquadMembership_Squads] FOREIGN KEY 
	(
		[SquadID]
	) REFERENCES [dbo].[Squads] (
		[SquadID]
	) ON DELETE CASCADE 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE dbo.p_edit_team_profile_aleg
	(
		@SquadID int,
		@Description varchar(510),
		@URL varchar(255),
		@ErrorCode int output,
		@ErrorMsg varchar(128) output
	)
AS
	SET NOCOUNT ON
	/* check if squad exist */
	declare @rc int
	select @rc = count(*) from Squads where SquadID = @SquadID
	if @rc <> 1
	begin
		select @ErrorCode = 1
		select @ErrorMsg = 'squad doesnt exist'
		return
	end
	update Squads set Description=@Description, URL=@URL
	 
	RETURN 

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE dbo.p_get_team_profile_aleg

	(
		@SquadID int
	)

AS
	/* SET NOCOUNT ON */
	/*
	return:
	(
	vc_team_id		varchar(30),
	vc_member_id		varchar(30),
	vc_description		varchar(510),
	vc_favorite_game1	varchar(4), 
	vc_favorite_game2	varchar(4),  
	vc_favorite_game3	varchar(4),  
	vc_favorite_game4	varchar(4),  
	vc_favorite_game5	varchar(4),  
	vc_favorite_link	varchar(255),
	b_closed			 bit,
	b_award				 bit,
	i_team_id			 int,  
	vc_edit_restrictions varchar(8),
	dt_created		     datetime
	)
	*/
	declare @vc_member_id as varchar(30)
	declare @f1 as	varchar(4) 
	declare @f2	as varchar(4)  
	declare @f3	as varchar(4)  
	declare @f4	as varchar(4)  
	declare @f5	as varchar(4)  
	declare @b_closed as bit 
	declare @b_award as bit
	declare @vc_edit_restrictions as varchar(8)
	
	
	select	SquadName as vc_team_id, @vc_member_id as vc_member_id, Description as vc_description,
			@f1 as vc_favorite_game1, @f2 as vc_favorite_game2, @f3 as vc_favorite_game3, @f4 as vc_favorite_game4, @f5 as vc_favorite_game5,
			URL as vc_favorite_link,
			@b_closed as b_closed,
			@b_award as b_award,
			SquadID as i_team_id,
			@vc_edit_restrictions as vc_edit_restrictions,
			dt_created
	from Squads 
	where SquadID = @SquadID 
			  
	RETURN 

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE dbo.p_change_team_ownership_aleg

	(
		@SquadID int,
		@NewOwnerID int,
		@ErrorCode int = 0 output, 
		@ErrorMsg varchar(128) = '' output
	)

AS
	SET NOCOUNT ON
	select @ErrorCode = 0
	select @ErrorMsg = ''

	update Squads set OwnerID = @NewOwnerID where SquadID = @SquadID
	update SquadMembership set i_status = 0 where SquadID = @SquadID and CharID = @NewOwnerID

RETURN 

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/* 
	create a squad
*/
CREATE PROCEDURE dbo.p_create_team_profile_aleg

	(
		@SquadName varchar(30),
		@Description varchar(510),
		@URL varchar(255),
		@OwnerID int,
		@SquadID int output,
		@ErrorCode int output,
		@ErrorMsg varchar(128) output
	)

AS
	SET NOCOUNT ON
	/* check if squad exist */
	declare @rc int
	select @rc = count(*) from Squads where SquadName = @SquadName
	if @rc > 0
	begin
		select @ErrorCode = 1
		select @ErrorMsg = 'squad already exists'
		return
	end
	/* do the insert */
	insert into Squads (SquadName,Description,URL, OwnerID) 
				values (@SquadName,@Description,@URL, @OwnerID)
	if @@ROWCOUNT <> 1
	begin
		select @ErrorCode = 2
		select @ErrorMsg = 'error creating new squad'
		return 
	end
	select @SquadID = SquadID from Squads where SquadName = @SquadName
	insert into SquadMembership (SquadID,CharID,i_status,i_secondary_status)
				values (@SquadID,@OwnerID,0,0)
	select @ErrorCode = 0
	select @ErrorMsg = ''
	return

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE dbo.p_deny_petitions_aleg

	(
		@SquadID int,
		@MemberID int,
		@ErrorCode int = 0 output,
		@ErrorMsg varchar(128) = '' output
	)

AS
	delete SquadMemberShip where SquadID = @SquadID and CharID = @MemberID and i_status = 2
	RETURN 

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Objet :  Procédure stockée dbo.p_edit_team_member_status2_aleg    Date du script : 03/04/2004 17:25:48 ******/
CREATE PROCEDURE dbo.p_edit_team_member_status2_aleg

	(
		@SquadID int,
		@MemberID int,
		@status2 int, /* 0=member|1=asl */
		@ErrorCode int = 0 output,
		@ErrorMsg varchar(128) = '' output	
	)

AS
	/* SET NOCOUNT ON */
	update SquadMembership set i_secondary_status = @status2 where SquadID=@SquadID and CharID=@MemberID
	RETURN 

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE dbo.p_get_player_teams_aleg
	(
		@characterID int
	)
AS
	SET NOCOUNT ON

	SELECT     Squads.SquadName as vc_team_name, SquadMembership.i_status, SquadMembership.SquadID AS i_team_id, SquadMembership.i_secondary_status
	FROM         SquadMembership INNER JOIN
	                      Squads ON SquadMembership.SquadID = Squads.SquadID
	WHERE SquadMembership.CharID = @characterID 	
	RETURN 

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE dbo.p_get_team_members_aleg

	(
		@SquadID int
	)

AS
	/* SET NOCOUNT ON */
	/* return:
	(
	[i_account_id] [int] NOT NULL ,
	[vc_member_id] [varchar] (30) NOT NULL , -- skipped
	[i_status] [int] NOT NULL ,
	[i_secondary_status] [int] NULL ,
	[dt_granted] [datetime] NOT NULL 
	)

	*/
	SELECT     SquadMembership.CharID AS i_account_id, SquadMembership.i_status, SquadMembership.i_secondary_status, SquadMembership.dt_granted
	FROM         SquadMembership INNER JOIN
	                      Squads ON SquadMembership.SquadID = Squads.SquadID
	WHERE     (Squads.SquadID = @SquadID) 
	RETURN 

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Objet :  Procédure stockée dbo.p_grant_petitions_aleg    Date du script : 03/04/2004 17:25:48 ******/
CREATE PROCEDURE dbo.p_grant_petitions_aleg

	(
		@SquadID int,
		@MemberID int,
		@ErrorCode int = 0 output,
		@ErrorMsg varchar(128) = '' output
	)

AS
	/* SET NOCOUNT ON */
	update SquadMembership
	set i_status = 1
	where SquadID = @SquadID and CharID = @MemberID and i_status = 2
	RETURN 

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE dbo.p_petition_team_aleg

	(
		@SquadID int,
		@MemberID int,
		@ErrorCode int = 0 output,
		@ErrorMsg varchar(128) = '' output
	)

AS
	/* SET NOCOUNT ON */
	declare @rc int
	-- check if not already member/pending
	select @rc = count(*) from SquadMembership where SquadID = @SquadID and CharID = @MemberID 
	if @rc > 0
	begin
		set @ErrorCode = -1
		set @ErrorMsg = 'already in membership list (member or pending)'
		return
	end
	insert into SquadMembership (SquadID,CharID,i_status)
				values (@SquadID,@MemberID,2)
	RETURN 

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE dbo.p_withdraw_team_aleg

	(
		@SquadID int,
		@MemberID int,
		@status int = null output,
		@NewOwnerID int = null output ,
		@ErrorCode int =  0 output ,
		@ErrorMsg varchar(128) = '' output 
	)

AS
	SET NOCOUNT ON
	-- remove player
	delete SquadMembership where SquadID=@SquadID and CharID=@MemberID
	declare @OwnerID int
	select @OwnerID = OwnerID from Squads where SquadID=@SquadID
	if @OwnerID = @MemberID
	begin -- change owner
		-- try an ASL
		SELECT     TOP 1 @NewOwnerID = CharID
		FROM         SquadMembership
		WHERE     (i_status <>2 ) and (i_secondary_status = 1) AND (SquadID = @SquadID)
		if @NewOwnerID is null
		begin -- no ASL found, select any member
			SELECT     TOP 1 @NewOwnerID = CharID
			FROM         SquadMembership
			WHERE  (i_status <> 2) and  (SquadID = @SquadID)
		end 
	end
	declare @rc int
	-- count members excluding pending ones
	select @rc=count(*) from SquadMembership where SquadID=@SquadID and i_status  <> 2
	if @rc = 0
	begin -- squad is empty
		delete Squads where SquadID = @SquadID 
		select @status = -1
		return
	end
	if @NewOwnerID is not null
	begin -- we got a new owner, update
		exec p_change_team_ownership_aleg @SquadID, @NewOwnerID, @ErrorCode, @ErrorMsg
	end
	RETURN 

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

exec sp_addextendedproperty N'MS_Description', null, N'user', N'dbo', N'table', N'SquadMembership', N'column', N'i_status'

GO


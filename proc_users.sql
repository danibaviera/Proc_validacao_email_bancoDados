-- SQL Procedure
CREATE OR ALTER PROCEDURE SUPORTE_ADD_USERS
(
    @UserManagerId BIGINT,
    @Name VARCHAR(255),
    @Email VARCHAR(255),
    @PermissionGroupName VARCHAR(100)
)
AS
BEGIN
    DECLARE @UserId BIGINT
    DECLARE @PermissionGroupId BIGINT

    -- Verificar se o e-mail já está cadastrado
    IF EXISTS (SELECT 1 FROM Employees WHERE Email = @Email)
        BEGIN
            RAISERROR('O e-mail já está cadastrado.', 16, 1)
            RETURN
        END

    SELECT @PermissionGroupId = PermissionGroupId FROM PermissionGroups
    WHERE UserManagerId = @UserManagerId AND Name = @PermissionGroupName

    INSERT INTO Users
    (CreatedAt, Timezone, UserManagerId, IsEnabled)
    VALUES
        (GETUTCDATE(), NULL, @UserManagerId, 1)

    SET @UserId = CONVERT(BIGINT, SCOPE_IDENTITY())

    INSERT INTO Employees
    (UserId, Name, UserManagerId, Email)
    VALUES
        (@UserId, @Name, @UserManagerId, @Email)

    INSERT INTO PermissionGroupsUsers
    (PermissionGroupId, UserId)
    VALUES
        (@PermissionGroupId, @UserId)
END

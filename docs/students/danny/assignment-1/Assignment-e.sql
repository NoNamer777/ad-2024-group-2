-- Stored Procedure
CREATE PROCEDURE ReturnItem
    @ReturnCode INT,
    @OrderDetailCode INT,
    @ReturnDate DATETIME,
    @ReturnQuantity SMALLINT,
    @ReturnReasonCode INT
AS
BEGIN
    INSERT INTO dbo.RETURNED_ITEM 
    (RETURN_CODE, ORDER_DETAIL_CODE, RETURN_DATE, RETURN_QUANTITY, RETURN_REASON_CODE)
    VALUES 
    (@ReturnCode, @OrderDetailCode, @ReturnDate, @ReturnQuantity, @ReturnReasonCode);
END

-- Trigger
CREATE TRIGGER trg_check_return_quantity
ON dbo.RETURNED_ITEM
AFTER INSERT, UPDATE
AS
BEGIN
    -- Check that return quantity doesn't exceed the ordered quantity
    IF EXISTS (
        SELECT 1
        FROM INSERTED i
        JOIN dbo.ORDER_DETAILS od ON i.ORDER_DETAIL_CODE = od.ORDER_DETAIL_CODE
        WHERE i.RETURN_QUANTITY > od.QUANTITY
    )
    BEGIN
        -- If return quantity is greater than ordered quantity, raise an error
        RAISERROR ('Return quantity cannot exceed the ordered quantity.', 16,1)
        ROLLBACK TRANSACTION;
    END
END;

--Function
CREATE FUNCTION GetProductPromotionsWithDiscount (
    @ProductNumber INT
)
RETURNS INT
AS
BEGIN
    DECLARE @PromotionCount INT;

    SELECT @PromotionCount = COUNT(*)
    FROM dbo.CAMPAIGN
    WHERE PRODUCT_NUMBER = @ProductNumber
    AND DISCOUNT > 1;

    RETURN @PromotionCount;
END;

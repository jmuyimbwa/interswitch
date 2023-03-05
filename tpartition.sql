-- Create the partition function
CREATE PARTITION FUNCTION pf_TransactionDateRange (DATE)
AS RANGE LEFT FOR VALUES 
('2019-01-01', '2020-01-01', '2021-01-01');

-- Create the partition scheme
CREATE PARTITION SCHEME ps_TransactionDateRange
AS PARTITION pf_TransactionDateRange 
TO 
(
    [PRIMARY],
    [fg_Transaction_2019],
    [fg_Transaction_2020],
    [fg_Transaction_2021]
);

-- Create the partitioned table
CREATE TABLE [dbo].[Transaction_Partitioned](
    [ID] [int] NOT NULL,
    [TransactionDate] [date] NOT NULL,
    [Amount] [decimal](18, 2) NOT NULL,
    CONSTRAINT [PK_Transaction_Partitioned] PRIMARY KEY CLUSTERED 
    (
        [ID] ASC,
        [TransactionDate] ASC
    ) ON ps_TransactionDateRange(TransactionDate)
) ON ps_TransactionDateRange(TransactionDate);

-- Switch the data to the partitioned table
ALTER TABLE [dbo].[Transaction] SWITCH TO [dbo].[Transaction_Partitioned] PARTITION 1;

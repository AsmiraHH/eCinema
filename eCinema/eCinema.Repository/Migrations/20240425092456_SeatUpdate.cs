using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eCinema.Repository.Migrations
{
    /// <inheritdoc />
    public partial class SeatUpdate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "isDisabled",
                table: "Seats",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.UpdateData(
                table: "Actors",
                keyColumn: "ID",
                keyValue: 1,
                column: "BirthDate",
                value: new DateTime(2024, 4, 25, 11, 24, 56, 19, DateTimeKind.Local).AddTicks(5240));

            migrationBuilder.UpdateData(
                table: "Employees",
                keyColumn: "ID",
                keyValue: 1,
                column: "BirthDate",
                value: new DateTime(2024, 4, 25, 11, 24, 56, 19, DateTimeKind.Local).AddTicks(5303));

            migrationBuilder.UpdateData(
                table: "Seats",
                keyColumn: "ID",
                keyValue: 1,
                column: "isDisabled",
                value: false);

            migrationBuilder.UpdateData(
                table: "Shows",
                keyColumn: "ID",
                keyValue: 1,
                column: "DateTime",
                value: new DateTime(2024, 4, 25, 11, 24, 56, 19, DateTimeKind.Local).AddTicks(5412));
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "isDisabled",
                table: "Seats");

            migrationBuilder.UpdateData(
                table: "Actors",
                keyColumn: "ID",
                keyValue: 1,
                column: "BirthDate",
                value: new DateTime(2024, 4, 19, 14, 29, 28, 411, DateTimeKind.Local).AddTicks(8191));

            migrationBuilder.UpdateData(
                table: "Employees",
                keyColumn: "ID",
                keyValue: 1,
                column: "BirthDate",
                value: new DateTime(2024, 4, 19, 14, 29, 28, 411, DateTimeKind.Local).AddTicks(8248));

            migrationBuilder.UpdateData(
                table: "Shows",
                keyColumn: "ID",
                keyValue: 1,
                column: "DateTime",
                value: new DateTime(2024, 4, 19, 14, 29, 28, 411, DateTimeKind.Local).AddTicks(8327));
        }
    }
}

using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eCinema.Repository.Migrations
{
    /// <inheritdoc />
    public partial class HallUpdate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "MaxNumberOfSeatsPerRow",
                table: "Hall",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "NumberOfRows",
                table: "Hall",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.UpdateData(
                table: "Actors",
                keyColumn: "ID",
                keyValue: 1,
                column: "BirthDate",
                value: new DateTime(2024, 4, 25, 19, 22, 16, 416, DateTimeKind.Local).AddTicks(9944));

            migrationBuilder.UpdateData(
                table: "Employees",
                keyColumn: "ID",
                keyValue: 1,
                column: "BirthDate",
                value: new DateTime(2024, 4, 25, 19, 22, 16, 416, DateTimeKind.Local).AddTicks(9994));

            migrationBuilder.UpdateData(
                table: "Hall",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "MaxNumberOfSeatsPerRow", "NumberOfRows" },
                values: new object[] { 0, 0 });

            migrationBuilder.UpdateData(
                table: "Shows",
                keyColumn: "ID",
                keyValue: 1,
                column: "DateTime",
                value: new DateTime(2024, 4, 25, 19, 22, 16, 417, DateTimeKind.Local).AddTicks(69));
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "MaxNumberOfSeatsPerRow",
                table: "Hall");

            migrationBuilder.DropColumn(
                name: "NumberOfRows",
                table: "Hall");

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
                table: "Shows",
                keyColumn: "ID",
                keyValue: 1,
                column: "DateTime",
                value: new DateTime(2024, 4, 25, 11, 24, 56, 19, DateTimeKind.Local).AddTicks(5412));
        }
    }
}

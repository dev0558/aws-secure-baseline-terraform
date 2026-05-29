# ADR 0004: Filter Local Zones out of AZ data source

## Status
Accepted, May 2026

## Context
The Mumbai region (ap-south-1) includes the Delhi Local Zone (ap-south-1-del-1a) in addition to the three standard Availability Zones. By default, data.aws_availability_zones returns all zones with state available, including Local Zones. The VPC module picked the first AZ for the single NAT Gateway. It landed on the Local Zone. NAT Gateway create failed with NotAvailableInZone.

## Decision
Filter the AZ data source to exclude opt-in zones (Local Zones and Wavelength Zones) by setting opt-in-status to opt-in-not-required.

## Consequences
1. VPC module only places resources in standard AZs.
2. The three subnets created in the Local Zone during the failed first apply were destroyed and recreated in standard AZs.
3. Lesson: when using aws_availability_zones, always filter by opt-in-status unless you specifically want Local Zone resources.

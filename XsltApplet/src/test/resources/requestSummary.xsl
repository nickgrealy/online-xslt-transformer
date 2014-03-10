<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0">

    <!--
		Main. Start processing from the /variable and control the display of the booklet tables
		from this block.
	-->
    <xsl:template match="/variable">
        <!--
		<xsl:apply-templates select="client" />
		-->

        <xsl:if test="archiveFlag/text() = 'true'">
            <xsl:apply-templates select="client" />
            <xsl:apply-templates select="planSummary/referral" />
        </xsl:if>


        <xsl:variable name="customer1" select="string-join((client/item[position() = 1]/person/title, client/item[position() = 1]/person/firstName, client/item[position() = 1]/person/lastName), ' ')" />
        <xsl:variable name="customer2" select="string-join((client/item[position() = 2]/person/title, client/item[position() = 2]/person/firstName, client/item[position() = 2]/person/lastName), ' ')" />
        <!--
		<xsl:apply-templates select="income | expenses">
			<xsl:with-param name="customer1" select="$customer1" />
			<xsl:with-param name="customer2" select="$customer2" />
		</xsl:apply-templates>
		<xsl:apply-templates select="assets" />
		<xsl:apply-templates select="liabilities" />	
				
		<xsl:apply-templates select="currentInvestments" />
		<xsl:apply-templates select="superannuation" >
			<xsl:with-param name="customer1" select="$customer1" />
			<xsl:with-param name="customer2" select="$customer2" />
		</xsl:apply-templates>
		<xsl:apply-templates select="insurance" />
		-->

        <xsl:if test="archiveFlag/text() = 'true'">
            <xsl:apply-templates select="income | expenses">
                <xsl:with-param name="customer1" select="$customer1" />
                <xsl:with-param name="customer2" select="$customer2" />
            </xsl:apply-templates>
            <xsl:apply-templates select="assets" />
            <xsl:apply-templates select="liabilities" />

            <xsl:apply-templates select="currentInvestments" />
            <xsl:apply-templates select="accounts" />
            <xsl:apply-templates select="superannuation" >
                <xsl:with-param name="customer1" select="$customer1" />
                <xsl:with-param name="customer2" select="$customer2" />
            </xsl:apply-templates>
            <xsl:apply-templates select="insurance" />
        </xsl:if>

        <xsl:apply-templates select="clientAuthorisation" />
        <xsl:apply-templates select="manualChecklist" />
        <xsl:apply-templates select="replacementChecklistLinks" />

    </xsl:template>

    <!--
		Print out the customer details
	-->
    <xsl:template match="/variable/client">
        <h2>Personal Details</h2>
        <table class="bookletTable">
            <xsl:for-each select="item">
                <xsl:variable name="isEntity" select="string-length(orgName) > 0" />
                <tr class="bookletRowHeader"><td colspan="4">Client <xsl:value-of select="position()" /> - Client ID : <xsl:value-of select="clientID" /></td></tr>

                <xsl:if test="$isEntity">
                    <tr>
                        <td class="bookletKeyColumn">Organisation Name </td><td><xsl:value-of select="orgName" /></td>
                        <td class="bookletKeyColumn">ABN</td><td><xsl:value-of select="abn" /></td>
                    </tr>
                    <tr>
                        <td class="bookletKeyColumn">Organisation Type</td><td><xsl:value-of select="orgType" /></td>
                        <td class="bookletKeyColumn">Principal Contact</td><td><xsl:value-of select="principalContact" /></td>
                    </tr>
                </xsl:if>
                <xsl:if test="not($isEntity)">
                    <tr>
                        <td class="bookletKeyColumn">Title</td><td><xsl:value-of select="person/title" /></td>
                        <td class="bookletKeyColumn">Gender</td><td><xsl:value-of select="person/gender" /></td>
                    </tr>
                    <tr>
                        <td class="bookletKeyColumn">Surname</td><td><xsl:value-of select="person/lastName" /></td>
                        <td class="bookletKeyColumn">Given Name</td><td><xsl:value-of select="person/firstName" /></td>
                    </tr>
                    <tr>
                        <td class="bookletKeyColumn">Date of Birth (DD-MM-YYYY)</td>
                        <td><xsl:value-of select="person/dateOfBirth" /></td>
                        <td class="bookletKeyColumn">Marital Status</td><td><xsl:value-of select="person/maritalStatus" /></td>
                    </tr>
                </xsl:if>
                <tr>
                    <td class="bookletKeyColumn">Residential Address</td>
                    <td>
                        <xsl:call-template name="formatAddress" >
                            <xsl:with-param name="theAddress" select="homeAddress" />
                        </xsl:call-template>
                    </td>
                    <td class="bookletKeyColumn">Postal Address</td>
                    <td>
                        <xsl:call-template name="formatAddress" >
                            <xsl:with-param name="theAddress" select="postalAddress" />
                        </xsl:call-template>
                    </td>
                </tr>
                <xsl:if test="not($isEntity)">
                    <tr>
                        <td class="bookletKeyColumn">Home Telephone</td><td><xsl:value-of select="contactDetails/homePhone" /></td>
                        <td class="bookletKeyColumn">Business Telephone</td><td><xsl:value-of select="contactDetails/workPhone" /></td>
                    </tr>

                    <tr>
                        <td class="bookletKeyColumn">Mobile</td><td><xsl:value-of select="contactDetails/mobilePhone" /></td>
                        <td class="bookletKeyColumn">Facsimile</td><td><xsl:value-of select="contactDetails/fax" /></td>
                    </tr>
                    <tr>
                        <td class="bookletKeyColumn">Email</td><td colspan="3"><xsl:value-of select="contactDetails/email" /></td>
                    </tr>
                    <tr>
                        <td class="bookletKeyColumn">Occupation</td><td><xsl:value-of select="occupation/occupation" /></td>
                        <td class="bookletKeyColumn">Employment Status</td><td><xsl:value-of select="occupation/employmentMode" /></td>
                    </tr>
                    <tr>
                        <td class="bookletKeyColumn">Employer's Name</td><td><xsl:value-of select="occupation/employerName" /></td>
                        <td class="bookletKeyColumn">Employer's Address</td>
                        <td>
                            <xsl:call-template name="formatAddress" >
                                <xsl:with-param name="theAddress" select="occupation/address" />
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <td class="bookletKeyColumn">Hours Per Week</td><td><xsl:value-of select="occupation/hoursPerWeek" /></td>
                        <td class="bookletKeyColumn">Date Employment Commenced</td><td><xsl:value-of select="occupation/hoursPerWeek" /></td>
                    </tr>
                    <tr>
                        <td class="bookletKeyColumn">Are you an Australian resident for taxation purposes?</td>
                        <td>
                            <xsl:call-template name="yesNoTemplate">
                                <xsl:with-param name="boolValue" select="occupation/taxPurposeAustraliaFlag/text()" />
                            </xsl:call-template>
                        </td>
                        <td class="bookletKeyColumn">If no, which country?</td><td><xsl:value-of select="occupation/taxPurposeCountry" /></td>
                    </tr>
                </xsl:if>

            </xsl:for-each>
        </table>

        <!-- old code Aug Release
		<table class="bookletTable">
			<tr class="bookletRowHeader">
				<td/>
				<td>Customer 1</td>
				<td>Customer 2</td>
			</tr>
			<xsl:call-template name="printCustomerRows" />
		</table>
		-->
    </xsl:template>

    <!--
		Print the customer details using the table definition 'Personal'.
	-->
    <xsl:template name="printCustomerRows" >
        <xsl:variable name="customer1" select="item[position() = 1]" />
        <xsl:variable name="customer2" select="item[position() = 2]" />
        <xsl:for-each select="$tableDefinitions/tables/table[@name='Personal']/tr" >
            <xsl:variable name="customerNode" select="@node" />
            <tr>
                <xsl:copy-of select="td" />
                <td>
                    <xsl:call-template name="printCustomerNodeValue">
                        <xsl:with-param name="theNode" select="$customer1/*[local-name() = $customerNode] | $customer1/*/*[local-name() = $customerNode]" />
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name="printCustomerNodeValue">
                        <xsl:with-param name="theNode" select="$customer2/*[local-name() = $customerNode] | $customer2/*/*[local-name() = $customerNode]" />
                    </xsl:call-template>
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>

    <!--
		Prints out the data value for an element wrapped in a <td>
	-->
    <xsl:template name="printCustomerNodeValue">
        <xsl:param name="theNode" />
        <xsl:choose>
            <xsl:when test="$theNode[@type = 'Address']">
                <xsl:call-template name="formatAddress" >
                    <xsl:with-param name="theAddress" select="$theNode" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="count($theNode/*) > 0">
                <!-- Do nothing. its an un mapped complex type and may be matched by other expressions. -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$theNode" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
		Formats an address element, i.e. @type='Address' as a 3 line HTML table 
	-->
    <xsl:template name="formatAddress">
        <xsl:param name="theAddress" />
        <xsl:value-of select="$theAddress/line1" />
        <xsl:if test="string-length($theAddress/line2) > 0">
            <br/><xsl:value-of select="$theAddress/line2" />,
        </xsl:if>
        <br/><xsl:value-of select="$theAddress/suburb" />, <xsl:value-of select="$theAddress/country" />
        <br/><i>State : </i><xsl:value-of select="$theAddress/state"/><i> , Postcode : </i><xsl:value-of select="$theAddress/postcode"/>
    </xsl:template>

    <!--
		Formats a number to contain commas up to 6 decimal places (if decimals exist)
	-->
    <xsl:template name="formatNumbers">
        <xsl:param name="number" />
        <xsl:value-of select="format-number($number, '###,###.0#####')" />
    </xsl:template>

    <!--
		Concatenates two fields, e.g. Other - More Information Required
	-->
    <xsl:template name="concatenateTwoFields">
        <xsl:param name="fieldOne" />
        <xsl:param name="fieldTwo" />
        <xsl:param name="separator" />
        <xsl:value-of select="$fieldOne" />
        <xsl:value-of select="$separator" />
        <xsl:value-of select="$fieldTwo" />
    </xsl:template>

    <!--
		Formats a field as the value of the 'other' variable unless 'other' = "Other" and the 'otherDetails' is not empty.
	-->
    <xsl:template name="genericFormatOther">
        <xsl:param name="other" />
        <xsl:param name="otherDetails" />
        <xsl:choose>
            <!--<xsl:when test="$other = 'Other' and $otherDetails != ''">-->
            <xsl:when test="lower-case($other) = 'other' and $otherDetails != ''">
                <xsl:call-template name="concatenateTwoFields" >
                    <xsl:with-param name="fieldOne" select="$other" />
                    <xsl:with-param name="fieldTwo" select="$otherDetails" />
                    <xsl:with-param name="separator" > - </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$other" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
		Formats the Asset Allocation Field. If the other allocation field is not empty
		it will display "Other - Other Field Details", otherwise
		it will display the asset allocation name.
	-->
    <xsl:template name="formatAssetAllocationDetails">
        <xsl:param name="existsFlag" />
        <xsl:param name="assetAllocation" />
        <xsl:param name="assetAllocationOther" />
        <xsl:if test="$existsFlag = 'true'">
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$existsFlag = 'true'">
                <!--
				<xsl:choose>
					<xsl:when test="$assetAllocation = 'Other' and $assetAllocationOther != ''">
						<xsl:call-template name="concatenateTwoFields" >
							<xsl:with-param name="fieldOne" select="productBenefits/assetAllocation" />
							<xsl:with-param name="fieldTwo" select="productBenefits/assetAllocationOther" />
							<xsl:with-param name="separator" > - </xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$assetAllocation" />
					</xsl:otherwise>
				</xsl:choose>
				-->
                <xsl:call-template name="genericFormatOther" >
                    <xsl:with-param name="other" select="$assetAllocation" />
                    <xsl:with-param name="otherDetails" select="$assetAllocationOther" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
		Print out the referral details
	-->
    <xsl:template match="/variable/planSummary/referral">
        <br/>
        <table class="bookletTable">
            <tr class="bookletRowHeader">
                <td colspan="2">Referral Source</td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Referral Type:</td><td><xsl:value-of select="source" /></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Referrer Name:</td><td><xsl:value-of select="string-join((employeeDetails/name, employeeDetails/salaryNumber), ' ')" /></td>
            </tr>
        </table>
    </xsl:template>

    <!--
		Print out the income or expenses details.
	-->
    <xsl:template match="variable/income | variable/expenses">
        <xsl:param name="customer1" />
        <xsl:param name="customer2" />
        <xsl:variable name="isIncome" select="local-name() = 'income'" />
        <xsl:choose>
            <xsl:when test="$isIncome"><h2>Income</h2></xsl:when>
            <xsl:otherwise><h2>Expenses</h2></xsl:otherwise>
        </xsl:choose>
        <p><b>Frequency: </b><xsl:value-of select="frequency" /></p>

        <!-- Added this section to handle multiple clients -->
        <table class="bookletTable">
            <tr class="bookletRowTallyHeader">
                <td>Owner</td>
                <td>Type</td>
                <td>Amount Taxable</td>
                <td>Amount Non Taxable</td>
            </tr>
            <xsl:for-each select="details/item">
                <tr>
                    <td><xsl:value-of select="owner" /></td>
                    <td><xsl:value-of select="type" /></td>
                    <td align="right">
                        <xsl:if test="amountTaxable">
                            <xsl:variable name="amountTaxableVar" select="amountTaxable" />
                            <xsl:value-of select='format-number($amountTaxableVar, "#,###,###.00")' />
                        </xsl:if>
                    </td>
                    <td align="right">
                        <xsl:if test="amountNonTaxable">
                            <xsl:variable name="amountNonTaxableVar" select="amountNonTaxable" />
                            <xsl:value-of select='format-number($amountNonTaxableVar, "#,###,###.00")' />
                        </xsl:if>
                    </td>
                </tr>
            </xsl:for-each>
            <xsl:choose>
                <xsl:when test="$isIncome">
                    <tr>
                        <td class="bookletStrongKeyColumn" colspan="3">Total combined income (before tax)</td>
                        <td align="right">
                            <xsl:if test="totalIncomeGross">
                                <xsl:variable name="totalIncomeGrossVar" select="totalIncomeGross" />
                                <xsl:value-of select='format-number($totalIncomeGrossVar, "#,###,###.00")' />
                            </xsl:if>
                        </td>
                    </tr>
                    <tr>
                        <td class="bookletStrongKeyColumn" colspan="3">Less: Estimated Tax</td>
                        <td align="right"><xsl:value-of select="estimatedTax" /></td>
                    </tr>
                    <tr>
                        <td class="bookletStrongKeyColumn" colspan="3">Less: Other deductions (e.g. salary sacrifices, salary packaging)</td>
                        <td align="right"><xsl:value-of select="otherDeductions" /></td>
                    </tr>
                    <tr>
                        <td class="bookletStrongKeyColumn" colspan="3">Net combined income (before tax)</td>
                        <td align="right">
                            <xsl:if test="totalIncomeNet">
                                <xsl:variable name="totalIncomeNetVar" select="totalIncomeNet" />
                                <xsl:value-of select='format-number($totalIncomeNetVar, "#,###,###.00")' />
                            </xsl:if>
                        </td>
                    </tr>
                </xsl:when>
                <xsl:otherwise>
                    <tr>
                        <td class="bookletStrongKeyColumn" colspan="3">Total combined expenses</td>
                        <td align="right">
                            <xsl:if test="totalCombined">
                                <xsl:variable name="totalCombinedVar" select="totalCombined" />
                                <xsl:value-of select='format-number($totalCombinedVar, "#,###,###.00")' />
                            </xsl:if>
                        </td>
                    </tr>
                    <tr>
                        <td class="bookletStrongKeyColumn" colspan="3">Surplus / deficit (total net combined income less total combined expenses)</td>
                        <td align="right">
                            <xsl:if test="surplusAmount">
                                <xsl:variable name="surplusAmountVar" select="surplusAmount" />
                                <xsl:value-of select='format-number($surplusAmountVar, "#,###,###.00")' />
                            </xsl:if>
                        </td>
                    </tr>

                </xsl:otherwise>
            </xsl:choose>

        </table>

        <!--
		<table class="bookletTable">
			<tr class="bookletRowTallyHeader">
				<td class="bookletHeaderNotTallyCell"><xsl:if test="$isIncome">Source of income (before tax)</xsl:if></td>
				<td>Customer 1 ($)</td>
				<td>Customer 2 ($)</td>
				<td>Joint ($)</td>
				<td>Non-taxable ($)</td>
			</tr>
			<tbody>
				<xsl:call-template name="printIncomeExpenseTableTable">
					<xsl:with-param name="customer1" select="$customer1" />
					<xsl:with-param name="customer2" select="$customer2" />
					<xsl:with-param name="isIncome" select="$isIncome" />
				</xsl:call-template>
				<xsl:call-template name="printOtherRows">
					<xsl:with-param name="customer1" select="$customer1" />
					<xsl:with-param name="customer2" select="$customer2" />
				</xsl:call-template>
				<xsl:call-template name="printIncomeExpenseTableFooter">
					<xsl:with-param name="customer1" select="$customer1" />
					<xsl:with-param name="customer2" select="$customer2" />
					<xsl:with-param name="isIncome" select="$isIncome" />
				</xsl:call-template>
			</tbody>
		</table>
		-->

        <xsl:if test="not($isIncome)">
            <xsl:call-template name="expenseSummaryTable" />
        </xsl:if>
    </xsl:template>

    <!--
		The summary of all expenses etc.
	-->
    <xsl:template name="expenseSummaryTable">
        <br/>
        <table class="bookletTable">
            <tr class="bookletRowTallyHeader">
                <td class="bookletHeaderNotTallyCell" colspan="2">Summary: Income, Expenses and Savings</td>
                <td>($)</td>
            </tr>
            <tbody>
                <tr>
                    <td class="bookletKeyColumn" colspan="2">What are your living costs? (from above)</td>
                    <td class="bookletTallyCell"><xsl:value-of select="totalCombined" /> p.a.</td>
                </tr>
                <tr>
                    <td class="bookletKeyColumn" colspan="2">How much do you or your household save each year?</td>
                    <td class="bookletTallyCell"><xsl:value-of select="yearlySavings" /> p.a.</td>
                </tr>
                <tr>
                    <td class="bookletKeyColumn" colspan="2">Do you expect any changes to your income and/or expenses?</td>
                    <td class="bookletTallyCell"><xsl:value-of select="incomeChangesFlag" /></td>
                </tr>
                <tr>
                    <td class="bookletKeyColumn">If yes, provide details</td>
                    <td class="bookletTallyCell" colspan="2"><xsl:value-of select="incomeChangeDetail" /></td>
                </tr>
                <tr>
                    <td class="bookletKeyColumn" colspan="2">How much readily accessible money do you expect you might need to meet emergencies and your day-to-day expenditure?</td>
                    <td class="bookletTallyCell"><xsl:value-of select="liquidFundsNeeded" /> p.a.</td>
                </tr>
                <tr>
                    <td class="bookletKeyColumn" colspan="1">How is your surplus used or deficit met?</td>
                    <td colspan="2"></td>
                </tr>
            </tbody>
        </table>
    </xsl:template>

    <!--
		Print the income expense table.
	-->
    <xsl:template name="printIncomeExpenseTableTable">
        <xsl:param name="customer1" />
        <xsl:param name="customer2" />
        <xsl:param name="isIncome" />

        <xsl:variable name="incomeExpenseRoot" select="." /> <!-- take a copy as lose context in the loop over tr. -->
        <xsl:variable name="tableDefName" select="local-name()" /> <!-- The name of the table def to use, derived from XML node name.-->

        <xsl:for-each select="$tableDefinitions/tables/table[@name=$tableDefName]/tr">
            <xsl:variable name="theType" select="@typePrefix" />
            <xsl:call-template name="printIncomeExpenseRow">
                <xsl:with-param name="income1" select="$incomeExpenseRoot/details/item[starts-with(type/text(), $theType) and owner/text() = $customer1]" />
                <xsl:with-param name="income2" select="$incomeExpenseRoot/details/item[starts-with(type/text(), $theType) and owner/text() = $customer2]" />
                <xsl:with-param name="joint" select="$incomeExpenseRoot/details/item[starts-with(type/text(), $theType) and owner/text() = 'Joint']" />
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <!--
		Prints out the 'Other' prefixed columns except for those that have already been printed.
	-->
    <xsl:template name="printOtherRows">
        <xsl:param name="customer1" />
        <xsl:param name="customer2" />
        <xsl:variable name="tableDefName" select="local-name()" /> <!-- The name of the table def to use, derived from XML node name.-->
        <xsl:for-each select="details/item[starts-with(type/text(), 'Other') and not(starts-with(type/text(), 'Other Debt Repayments'))]">
            <xsl:variable name="income1" select=".[owner/text() = $customer1]" />
            <xsl:variable name="income2" select=".[owner/text() = $customer2]" />
            <xsl:variable name="joint" select=".[owner/text() = 'Joint']" />
            <tr>
                <td  class="bookletKeyColumn"><xsl:value-of select="type" /></td>
                <td class="bookletTallyCell"><xsl:value-of select="$income1/amountTaxable" /></td>
                <td class="bookletTallyCell"><xsl:value-of select="$income2/amountTaxable" /></td>
                <td class="bookletTallyCell"><xsl:value-of select="$joint/amountTaxable/text()" /></td>
                <td class="bookletTallyCell"><xsl:value-of select="sum(($income1/amountNonTaxable, $income2/amountNonTaxable, $joint/amountNonTaxable))" /></td>
            </tr>
        </xsl:for-each>
    </xsl:template>

    <!-- Print Individual column definitions in the table. -->
    <xsl:template name="printIncomeExpenseRow">
        <xsl:param name="income1" />
        <xsl:param name="income2" />
        <xsl:param name="joint" />
        <tr>
            <xsl:copy-of select="td" />
            <td class="bookletTallyCell"><xsl:value-of select="$income1/amountTaxable" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="$income2/amountTaxable" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="$joint/amountTaxable/text()" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="sum(($income1/amountNonTaxable, $income2/amountNonTaxable, $joint/amountNonTaxable))" /></td>
        </tr>
    </xsl:template>

    <!--
		Handle printing the footer for either the income or expenses table
	-->
    <xsl:template name="printIncomeExpenseTableFooter">
        <xsl:param name="customer1" />
        <xsl:param name="customer2" />
        <xsl:param name="isIncome" />
        <xsl:choose>
            <xsl:when test="$isIncome">
                <xsl:call-template name="printIncomeTableFooter">
                    <xsl:with-param name="customer1" select="$customer1" />
                    <xsl:with-param name="customer2" select="$customer2" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="printExpenseTableFooter">
                    <xsl:with-param name="customer1" select="$customer1" />
                    <xsl:with-param name="customer2" select="$customer2" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--
		Print the income table - footer.
	-->
    <xsl:template name="printIncomeTableFooter">
        <xsl:param name="customer1" />
        <xsl:param name="customer2" />

        <tr>
            <td class="bookletStrongKeyColumn">Subtotal Income</td>
            <td class="bookletTallyCell"><xsl:value-of select="sum(details/item[owner/text() = $customer1]/amountTaxable)" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="sum(details/item[owner/text() = $customer2]/amountTaxable)" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="sum(details/item[owner/text() = 'Joint']/amountTaxable)" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="sum(details/item/amountNonTaxable)" /></td>
        </tr>
        <tr>
            <td class="bookletStrongKeyColumn" colspan="4">Total combined income (before tax)</td>
            <td class="bookletTallyCell" align="right">
                <xsl:if test="totalIncomeGross">
                    <xsl:variable name="totalIncomeGrossVar" select="totalIncomeGross" />
                    <xsl:value-of select='format-number($totalIncomeGrossVar, "#,###,###.00")' />
                </xsl:if>
            </td>
        </tr>
        <tr>
            <td class="bookletStrongKeyColumn" colspan="4">Less: Estimated Tax</td><td class="bookletTallyCell"><xsl:value-of select="estimatedTax" /></td>
        </tr>
        <tr>
            <td class="bookletStrongKeyColumn" colspan="4">Less: Other deductions (e.g. salary sacrifices, salary packaging)</td><td class="bookletTallyCell"><xsl:value-of select="otherDeductions" /></td>
        </tr>
        <tr>
            <td class="bookletStrongKeyColumn" colspan="4">Net combined income (before tax)</td><td class="bookletTallyCell"><xsl:value-of select="totalIncomeNet" /></td>
        </tr>
    </xsl:template>

    <!--
		Print the expense table - footer.
	-->
    <xsl:template name="printExpenseTableFooter">
        <xsl:param name="customer1" />
        <xsl:param name="customer2" />

        <tr>
            <td class="bookletStrongKeyColumn">Subtotal Expenses</td>
            <td class="bookletTallyCell"><xsl:value-of select="sum(details/item[owner/text() = $customer1]/amountTaxable)" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="sum(details/item[owner/text() = $customer2]/amountTaxable)" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="sum(details/item[owner/text() = 'Joint']/amountTaxable)" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="sum(details/item/amountNonTaxable)" /></td>
        </tr>
        <tr>
            <td class="bookletStrongKeyColumn" colspan="4">Total combined expenses</td><td class="bookletTallyCell"><xsl:value-of select="totalCombined" /></td>
        </tr>
        <tr>
            <td class="bookletStrongKeyColumn" colspan="4">Surplus / deficit (total net combined income less total combined expenses)</td><td class="bookletTallyCell"><xsl:value-of select="surplusAmount" /></td>
        </tr>
    </xsl:template>

    <!--
		Setup up the table and asset header and print out all assets
	-->
    <xsl:template match="/variable/assets">
        <h2>Assets &amp; Liabilities</h2>
        <h3>Lifestyle &amp; Business Assets</h3>
        <table class="bookletTable">
            <tr class="bookletRowTallyHeader">
                <td></td>
                <td>Amount($)</td>
                <td>Owner</td>
                <td>Date Purchased</td>
                <td>Insured and up to date?</td>
                <td>Insurer</td>
                <td>Sum Insured ($)</td>
                <td>Premium ($)</td>
                <td>Centrelink Value($)</td>
            </tr>
            <tbody>
                <xsl:apply-templates select="item" />
            </tbody>
        </table>
    </xsl:template>

    <!--
		Print out the asset detail
	-->
    <xsl:template match="/variable/assets/item">
        <tr>
            <td class="bookletKeyColumn"><xsl:value-of select="type" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="value" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="owner" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="purchaseDate" /></td>
            <td class="bookletTallyCell">
                <xsl:call-template name="yesNoTemplate">
                    <xsl:with-param name="boolValue" select="insuredFlag/text()" />
                </xsl:call-template>
            </td>
            <td class="bookletTallyCell"><xsl:value-of select="insurer" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="amountInsured" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="premium" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="centreLinkValue" /></td>
        </tr>
    </xsl:template>

    <!--
		Setup up the table and liabilities header and print out all liabilities
	-->
    <xsl:template match="/variable/liabilities">
        <h3>Liabilities</h3>
        <table class="bookletTable">
            <tr class="bookletRowTallyHeader">
                <td></td>
                <td>Lender</td>
                <td>Owner</td>
                <td>Facility / Limit($)</td>
                <td>Balance($)</td>
                <td>Interest Rate(%)</td>
                <td>P&amp;I or Interest. Only</td>
                <td>Term</td>
                <td>Monthly Repayment($)</td>
                <td>Secured Against</td>
                <td>Deductable</td>
            </tr>
            <tbody>
                <xsl:apply-templates select="item" />
            </tbody>
        </table>
        <xsl:call-template name="printLiabilityGuarantorTable" />
    </xsl:template>

    <!--
		Print Guarantors table indicating if there are guarantors on the loans
	-->
    <xsl:template name="printLiabilityGuarantorTable" >
        <br/>
        <xsl:variable name="allGuarantors" select="item[string-length(guarantor/text()) > 0]" />
        <table class="bookletTable">
            <tbody>
                <tr>
                    <td class="bookletKeyColumn" colspan="2">Does anyone act as a loan guarantor over any of these loan obligations?</td>
                    <td>
                        <xsl:choose>
                            <xsl:when test="count($allGuarantors) > 0">Yes</xsl:when>
                            <xsl:otherwise>No</xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
                <tr>
                    <td class="bookletKeyColumn">If yes, please specify the name of the guarantor(s) and for which loan(s)</td>
                    <td colspan="2">
                        <xsl:for-each select="$allGuarantors" >
                            <xsl:if test="position() > 1">,</xsl:if>
                            Guarantor: <xsl:value-of select="guarantor" /> for <xsl:value-of select="type" />
                        </xsl:for-each>
                    </td>
                </tr>
            </tbody>
        </table>
    </xsl:template>

    <!--
		Print out the liability detail
	-->
    <xsl:template match="/variable/liabilities/item">
        <tr>
            <td class="bookletKeyColumn"><xsl:value-of select="type" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="lender" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="owner" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="amount" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="balance" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="intRate" /></td>
            <td class="bookletTallyCell">
                <xsl:choose>
                    <xsl:when test="intOnlyFlag/text() = 'true'">P&amp;I</xsl:when>
                    <xsl:otherwise>Interest Only</xsl:otherwise>
                </xsl:choose>
            </td>
            <td class="bookletTallyCell"><xsl:value-of select="term" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="monthlyRepayment" /></td>
            <td class="bookletTallyCell"><xsl:value-of select="security" /></td>
            <td class="bookletTallyCell">
                <xsl:call-template name="yesNoTemplate">
                    <xsl:with-param name="boolValue" select="deductibleFlag/text()" />
                </xsl:call-template>
            </td>
        </tr>
    </xsl:template>

    <!--
		All of the investment type tables.
	-->
    <xsl:template match="/variable/currentInvestments">
        <h3>Investment and Savings</h3>
        <xsl:apply-templates select="investmentsCash" />
        <xsl:apply-templates select="investmentsProperty" />
        <xsl:apply-templates select="investmentsShares" />
        <xsl:apply-templates select="investmentsSavings" />
    </xsl:template>

    <!--
	-->
    <xsl:template match="/variable/currentInvestments/investmentsCash" >
        <br/>
        <table class="bookletTable">
            <tbody>
                <tr class="bookletRowTallyHeader">
                    <td class="bookletHeaderNotTallyCell">Cash and fixed interest investments</td>
                    <td>Owner</td>
                    <td>Current value($)</td>
                    <td>Interest rate(%) pa</td>
                    <td>Purchase price ($)</td>
                    <td>Purchase date</td>
                    <td>Maturity date</td>
                    <td>Reinvest income</td>
                    <td>Amount ($ or %) to re-allocate</td>
                </tr>
                <xsl:choose>
                    <xsl:when test="count(item) > 0">
                        <xsl:for-each select="item">
                            <tr>
                                <td><xsl:value-of select="account" /></td>
                                <td class="bookletTallyCell"><xsl:value-of select="owner" /></td>
                                <td class="bookletTallyCell"><xsl:value-of select="value" /> as at (<xsl:value-of select="valueAsAt" />)</td>
                                <td class="bookletTallyCell"><xsl:value-of select="intRate" /></td>
                                <td class="bookletTallyCell"><xsl:value-of select="purchasePrice" /></td>
                                <td class="bookletTallyCell"><xsl:value-of select="purchaseDate" /></td>
                                <td class="bookletTallyCell"><xsl:value-of select="maturityDate" /></td>
                                <td class="bookletTallyCell">
                                    <xsl:call-template name="yesNoTemplate">
                                        <xsl:with-param name="boolValue" select="reinvestFlag/text()" />
                                    </xsl:call-template>
                                </td>
                                <td class="bookletTallyCell">
                                    <xsl:call-template name="dollarPercentTemplate">
                                        <xsl:with-param name="unit" select="allocationMethod/text()" />
                                        <xsl:with-param name="unitValue" select="allocationValue/text()" />
                                    </xsl:call-template>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr><td></td><td /><td /><td /><td /><td /><td /><td /><td /></tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
    </xsl:template>

    <!--
	-->
    <xsl:template match="/variable/currentInvestments/investmentsProperty" >
        <br/>
        <table class="bookletTable">
            <tbody>
                <tr class="bookletRowTallyHeader">
                    <td class="bookletHeaderNotTallyCell">Direct property investments</td>
                    <td>Owner</td>
                    <td>Current value ($)</td>
                    <td>Rental income ($)</td>
                    <td>Purchase price ($)</td>
                    <td>Purchase date</td>
                    <td>Mortgaged</td>
                    <td>Re-allocate</td>
                </tr>
                <xsl:choose>
                    <xsl:when test="count(item) > 0">
                        <xsl:for-each select="item">
                            <tr>
                                <td><xsl:value-of select="account" /></td>
                                <td class="bookletTallyCell"><xsl:value-of select="owner" /></td>
                                <td class="bookletTallyCell"><xsl:value-of select="value" /> as at (<xsl:value-of select="valueAsAt" />)</td>
                                <td class="bookletTallyCell"><xsl:value-of select="rentalIncome" /></td>
                                <td class="bookletTallyCell"><xsl:value-of select="purchasePrice" /></td>
                                <td class="bookletTallyCell"><xsl:value-of select="purchaseDate" /></td>
                                <td class="bookletTallyCell">
                                    <xsl:call-template name="yesNoTemplate">
                                        <xsl:with-param name="boolValue" select="mortgagedFlag/text()" />
                                    </xsl:call-template>
                                </td>
                                <td class="bookletTallyCell">
                                    <xsl:call-template name="yesNoTemplate">
                                        <xsl:with-param name="boolValue" select="reallocateFlag/text()" />
                                    </xsl:call-template>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr><td /><td /><td /><td /><td /><td /><td /><td /></tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
    </xsl:template>


    <!--
	-->
    <xsl:template match="/variable/currentInvestments/investmentsShares" >
        <br/>
        <table class="bookletTable">
            <tbody>
                <tr class="bookletRowTallyHeader">
                    <td class="bookletHeaderNotTallyCell">Shares and managed funds</td>
                    <td>Owner</td>
                    <td>Current value($)</td>
                    <td>Purchase price ($)</td>
                    <td>Total units / shares</td>
                    <td>Purchase date</td>
                    <td>Geared</td>
                    <td>Reinvest income</td>
                    <td>Amount ($ or %) to re-allocate</td>
                </tr>
                <xsl:choose>
                    <xsl:when test="count(item) > 0">
                        <xsl:for-each select="item">
                            <tr>
                                <td><xsl:value-of select="account" /></td>
                                <td class="bookletTallyCell"><xsl:value-of select="owner" /></td>
                                <td class="bookletTallyCell"><xsl:value-of select="value" /> as at (<xsl:value-of select="valueAsAt" />)</td>
                                <td class="bookletTallyCell"><xsl:value-of select="purchasePrice" /></td>
                                <td class="bookletTallyCell"><xsl:value-of select="totalUnits" /></td>
                                <td class="bookletTallyCell"><xsl:value-of select="purchaseDate" /></td>
                                <td class="bookletTallyCell">
                                    <xsl:call-template name="yesNoTemplate">
                                        <xsl:with-param name="boolValue" select="gearedFlag/text()" />
                                    </xsl:call-template>
                                </td>
                                <td class="bookletTallyCell">
                                    <xsl:call-template name="yesNoTemplate">
                                        <xsl:with-param name="boolValue" select="reinvestFlag/text()" />
                                    </xsl:call-template>
                                </td>
                                <td class="bookletTallyCell">
                                    <xsl:call-template name="dollarPercentTemplate">
                                        <xsl:with-param name="unit" select="allocationMethod/text()" />
                                        <xsl:with-param name="unitValue" select="allocationValue/text()" />
                                    </xsl:call-template>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr><td></td><td /><td /><td /><td /><td /><td /><td /><td /></tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
    </xsl:template>


    <!--
	-->
    <xsl:template match="/variable/currentInvestments/investmentsSavings" >
        <br/>
        <table class="bookletTable">
            <tbody>
                <tr class="bookletRowTallyHeader">
                    <td class="bookletHeaderNotTallyCell">Savings plans</td>
                    <td>Owner</td>
                    <td>Amount ($)</td>
                    <td>Start date</td>
                    <td>Term</td>
                    <td>Frequency</td>
                </tr>
                <xsl:choose>
                    <xsl:when test="count(item) > 0">
                        <xsl:for-each select="item">
                            <tr>
                                <td><xsl:value-of select="account" /></td>
                                <td class="bookletTallyCell"><xsl:value-of select="owner" /></td>
                                <td class="bookletTallyCell"><xsl:value-of select="value" /> <!--as at (<xsl:value-of select="valueAsAt" />)--></td>
                                <td class="bookletTallyCell"><xsl:value-of select="startDate" /></td>
                                <td class="bookletTallyCell">
                                    <xsl:call-template name="yesNoTemplate">
                                        <xsl:with-param name="boolValue" select="termFlag/text()" />
                                    </xsl:call-template>
                                </td>
                                <td class="bookletTallyCell"><xsl:value-of select="frequency" /></td>
                            </tr>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr><td></td><td /><td /><td /><td /><td /></tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
    </xsl:template>

    <!--
		All of the account type tables.
	-->
    <xsl:template match="/variable/accounts">
        <xsl:apply-templates select="accountExternal" />
        <xsl:apply-templates select="accountInternal" />
    </xsl:template>

    <xsl:template match="/variable/accounts/accountExternal" >
        <br/>
        <h3>External Products</h3>

        <table class="bookletTable">
            <tbody>
                <tr class="bookletRowTallyHeader">
                    <td>Owner</td>
                    <td>Description</td>
                    <td>Account Limit </td>
                    <td>Balance Amount</td>
                </tr>
                <xsl:choose>
                    <xsl:when test="count(item) > 0">
                        <xsl:for-each select="item">
                            <tr>
                                <td><xsl:value-of select="owner" /></td>
                                <td><xsl:value-of select="product/description" /></td>
                                <td align="right">
                                    <xsl:if test="accountLimit">
                                        <xsl:variable name="accountLimit" select="accountLimit" />
                                        $<xsl:value-of select='format-number($accountLimit, "#,###,###.00")' />
                                    </xsl:if>
                                </td>
                                <td align="right">
                                    <xsl:if test="balanceAmount">
                                        <xsl:variable name="balanceAmount" select="balanceAmount" />
                                        $<xsl:value-of select='format-number($balanceAmount, "#,###,###.00")' />
                                    </xsl:if>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr><td></td><td /><td /><td /></tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template match="/variable/accounts/accountInternal" >
        <br/>
        <h3>Existing Products</h3>

        <table class="bookletTable">
            <tbody>
                <tr class="bookletRowTallyHeader">
                    <td>Owner</td>
                    <td>Description</td>
                    <td>Limit </td>
                    <td>Balance Amount</td>
                    <td>Tb Prod Type</td>
                </tr>
                <xsl:choose>
                    <xsl:when test="count(item) > 0">
                        <xsl:for-each select="item">
                            <tr>
                                <td><xsl:value-of select="owner" /></td>
                                <td><xsl:value-of select="product/description" /></td>
                                <td align="right">
                                    <xsl:if test="limit">
                                        <xsl:variable name="limit" select="limit" />
                                        $<xsl:value-of select='format-number($limit, "#,###,###.00")' />
                                    </xsl:if>
                                </td>
                                <td align="right">
                                    <xsl:if test="balanceAmount">
                                        <xsl:variable name="balanceAmount" select="balanceAmount" />
                                        $<xsl:value-of select='format-number($balanceAmount, "#,###,###.00")' />
                                    </xsl:if>
                                </td>
                                <td><xsl:value-of select="tbProdType" /></td>
                            </tr>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr><td></td><td /><td /><td /></tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
    </xsl:template>

    <!--
		Matches the root superannuation and prints out all the nodes beneath it.
	-->
    <xsl:template match="/variable/superannuation" >
        <xsl:param name="customer1" />
        <xsl:param name="customer2" />
        <h2>Superannuation &amp; Income Streams</h2>
        <xsl:apply-templates select="superannuationDetails" />

        <xsl:apply-templates select="previousContributions" />
        <!--
		<xsl:apply-templates select="previousContributions" >
			<xsl:with-param name="customer1" select="$customer1" />
			<xsl:with-param name="customer2" select="$customer2" />
		</xsl:apply-templates>
		-->
        <xsl:apply-templates select="incomeStreamDetails" />
        <xsl:apply-templates select="redundancyEarlyRetirementPayments" />
    </xsl:template>

    <xsl:template match="/variable/superannuation/superannuationDetails">
        <h3>Superannuation Details</h3>
        <table class="bookletTable">
            <tbody>
                <tr class="bookletRowTallyHeader">
                    <td class="bookletHeaderNotTallyCell">Superannuation &amp;/or Rollover Funds*</td>
                    <td>Owner</td>
                    <td>Current value ($)</td>
                    <td>Regular contribution received p.a. ($)</td>
                    <td>Super Choice</td>
                    <td>Amount ($ or %) to re-allocate</td>
                </tr>
                <xsl:choose>
                    <xsl:when test="count(item) > 0">
                        <xsl:for-each select="item">
                            <tr>
                                <td><xsl:value-of select="funds" /></td>
                                <td class="bookletTallyCell"><xsl:value-of select="owner" /></td>
                                <td class="bookletTallyCell"><xsl:value-of select="currentValue" /></td>
                                <td class="bookletTallyCell"><xsl:value-of select="regularContributionReceived" /></td>
                                <td class="bookletTallyCell">
                                    <xsl:call-template name="yesNoTemplate">
                                        <xsl:with-param name="boolValue" select="superChoice/text()" />
                                    </xsl:call-template>
                                </td>
                                <td class="bookletTallyCell"><xsl:value-of select="amountToBeRelocated" /></td>
                            </tr>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <tr><td></td><td /><td /><td /><td /><td /></tr>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
        <p>* Where the fund is a SMSF, please complete the SMSF Investment Strategy Workbook</p>
    </xsl:template>

    <!--
		Prints out the previous years superannuation details.
	-->
    <xsl:template match="/variable/superannuation/previousContributions">
        <h3>Previous Contribution Amounts</h3>

        <!-- Added this section to handle multiple clients -->
        <table class="bookletTable">
            <tbody>
                <tr class="bookletRowTallyHeader">
                    <td colspan="4">Current Financial Year</td>
                </tr>
                <tr class="bookletRowTallyHeader">
                    <td class="bookletKeyColumn">Year Ending</td>
                    <td class="bookletKeyColumn">Sg Contribution ($)</td>
                    <td class="bookletKeyColumn">Other Consession Amount. ($)</td>
                    <td>Non Consessional Amount</td>
                </tr>
                <xsl:for-each select="currentFinancialYear/item">
                    <tr>
                        <td>
                            <xsl:call-template name="formatTWDate" >
                                <xsl:with-param name="dateValue" select="yearEnding" />
                            </xsl:call-template>
                        </td>
                        <td><xsl:value-of select="sgContribution" /></td>
                        <td><xsl:value-of select="otherConcessionalAmount" /></td>
                        <td><xsl:value-of select="nonConsessionalAmount" /></td>
                    </tr>
                </xsl:for-each>
                <tr class="bookletRowTallyHeader">
                    <td colspan="4">Previous Two Financial Year</td>
                </tr>
                <tr class="bookletRowTallyHeader">
                    <td class="bookletKeyColumn">Year Ending</td>
                    <td class="bookletKeyColumn">Sg Contribution ($)</td>
                    <td class="bookletKeyColumn">Other Consession Amount. ($)</td>
                    <td>Non Consessional Amount</td>
                </tr>
                <xsl:for-each select="previousTwoFinancialYear/item">
                    <tr>
                        <td>
                            <xsl:call-template name="formatTWDate" >
                                <xsl:with-param name="dateValue" select="yearEnding" />
                            </xsl:call-template>
                        </td>
                        <td><xsl:value-of select="sgContribution" /></td>
                        <td><xsl:value-of select="otherConcessionalAmount" /></td>
                        <td><xsl:value-of select="nonConsessionalAmount" /></td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>

        <!--
		<xsl:param name="customer1" />
		<xsl:param name="customer2" />
		<h3>Previous Contribution Amounts</h3>
		<xsl:variable name="currentSuper1" select="currentFinancialYear/item[owner/text() = $customer1]" />
		<xsl:variable name="currentSuper2" select="currentFinancialYear/item[owner/text() = $customer2]" />
		<xsl:variable name="previousYears1" select="previousTwoFinancialYear/item[owner/text() = $customer1]" />
		<xsl:variable name="previousYears2" select="previousTwoFinancialYear/item[owner/text() = $customer1]" />
		<table class="bookletTable">
			<tbody>
				<tr class="bookletRowTallyHeader"><td colspan="2"></td><td>Customer 1</td><td>Customer 2</td></tr>
				<tr><td class="bookletStrongKeyColumn" colspan="4">Current Financial Year</td></tr>
				<tr>
					<td class="bookletKeyColumn" colspan="2">Year ending</td>
					<td class="bookletTallyCell"><xsl:value-of select="$currentSuper1/yearEnding" /></td>
					<td class="bookletTallyCell"><xsl:value-of select="$currentSuper2/yearEnding" /></td>
				</tr>
				<tr>
					<td class="bookletKeyColumn" colspan="2">SG contribution</td>
					<td class="bookletTallyCell"><xsl:value-of select="$currentSuper1/sgContribution" /></td>
					<td class="bookletTallyCell"><xsl:value-of select="$currentSuper2/sgContribution" /></td>
				</tr>
				<tr>
					<td class="bookletKeyColumn" colspan="2">Other concessional amount</td>
					<td class="bookletTallyCell"><xsl:value-of select="$currentSuper1/otherConcessionalAmount" /></td>
					<td class="bookletTallyCell"><xsl:value-of select="$currentSuper2/otherConcessionalAmount" /></td>
				</tr>
				<tr>
					<td class="bookletKeyColumn" colspan="2">Non-concessional amount</td>
					<td class="bookletTallyCell"><xsl:value-of select="$currentSuper1/nonConcessionalAmount" /></td>
					<td class="bookletTallyCell"><xsl:value-of select="$currentSuper2/nonConcessionalAmount" /></td>
				</tr>
				<tr><td class="bookletStrongKeyColumn" colspan="4">Previous two(2) Financial Years</td></tr>
				<tr>
					<td class="bookletKeyColumn" colspan="2">Year ending</td>
					<td class="bookletTallyCell"><xsl:value-of select="$previousYears1[position() = 1]/yearEnding" /></td>
					<td class="bookletTallyCell"><xsl:value-of select="$previousYears2[position() = 1]/yearEnding" /></td>
				</tr>
				<tr>
					<td class="bookletKeyColumn" colspan="2">SG contribution</td>
					<td class="bookletTallyCell"><xsl:value-of select="$previousYears1[position() = 1]/sgContribution" /></td>
					<td class="bookletTallyCell"><xsl:value-of select="$previousYears2[position() = 1]/sgContribution" /></td>
				</tr>
				<tr>
					<td class="bookletKeyColumn" colspan="2">Other concessional amount</td>
					<td class="bookletTallyCell"><xsl:value-of select="$previousYears1[position() = 1]/otherConcessionalAmount" /></td>
					<td class="bookletTallyCell"><xsl:value-of select="$previousYears2[position() = 1]/otherConcessionalAmount" /></td>
				</tr>
				<tr>
					<td class="bookletKeyColumn" colspan="2">Non-concessional amount</td>
					<td class="bookletTallyCell"><xsl:value-of select="$previousYears1[position() = 1]/nonConcessionalAmount" /></td>
					<td class="bookletTallyCell"><xsl:value-of select="$previousYears2[position() = 1]/nonConcessionalAmount" /></td>
				</tr>
				<tr>
					<td class="bookletKeyColumn" colspan="2">Year ending</td>
					<td class="bookletTallyCell"><xsl:value-of select="$previousYears1[position() = 2]/yearEnding" /></td>
					<td class="bookletTallyCell"><xsl:value-of select="$previousYears2[position() = 2]/yearEnding" /></td>
				</tr>
				<tr>
					<td class="bookletKeyColumn" colspan="2">SG contribution</td>
					<td class="bookletTallyCell"><xsl:value-of select="$previousYears1[position() = 2]/sgContribution" /></td>
					<td class="bookletTallyCell"><xsl:value-of select="$previousYears2[position() = 2]/sgContribution" /></td>
				</tr>
				<tr>
					<td class="bookletKeyColumn" colspan="2">Other concessional amount</td>
					<td class="bookletTallyCell"><xsl:value-of select="$previousYears1[position() = 2]/otherConcessionalAmount" /></td>
					<td class="bookletTallyCell"><xsl:value-of select="$previousYears2[position() = 2]/otherConcessionalAmount" /></td>
				</tr>
				<tr>
					<td class="bookletKeyColumn" colspan="2">Non-concessional amount</td>
					<td class="bookletTallyCell"><xsl:value-of select="$previousYears1[position() = 2]/nonConcessionalAmount" /></td>
					<td class="bookletTallyCell"><xsl:value-of select="$previousYears2[position() = 2]/nonConcessionalAmount" /></td>
				</tr>
			</tbody>
		</table>
		-->
    </xsl:template>

    <!--
		Print out all the income streams by owner.
	-->
    <xsl:template match="/variable/superannuation/incomeStreamDetails">
        <h3>Income Stream Details</h3>
        <xsl:variable name="incomeStreams" select="." />
        <!-- Added this section to handle multiple clients -->

        <table class="bookletTable">
            <tbody>
                <xsl:for-each select="item">
                    <tr class="bookletRowTallyHeader">
                        <td colspan="4">Income Stream Details - <xsl:value-of select="position()" /></td>
                    </tr>
                    <tr>
                        <td  class="bookletKeyColumn">Owner</td>
                        <td><xsl:value-of select="owner" /></td>
                        <td  class="bookletKeyColumn">Fund name</td>
                        <td><xsl:value-of select="fundName" /></td>
                    </tr>
                    <tr>
                        <td  class="bookletKeyColumn">Pension / annuity type</td>
                        <td><xsl:value-of select="pensionAnnuityType" /></td>
                        <td  class="bookletKeyColumn">Complying (Centrelink)</td>
                        <td><xsl:value-of select="complyingCentrelink" /></td>
                    </tr>
                    <tr>
                        <td  class="bookletKeyColumn">Date of purchase</td>
                        <td>
                            <xsl:call-template name="formatTWDate" >
                                <xsl:with-param name="dateValue" select="dateOfPurchase" />
                            </xsl:call-template>
                        </td>
                        <td  class="bookletKeyColumn">Investment amount</td>
                        <td>
                            <xsl:if test="investmentAmount">
                                <xsl:variable name="investmentAmountVar" select="investmentAmount" />
                                $<xsl:value-of select='format-number($investmentAmountVar, "#,###,###.00")' />
                            </xsl:if>
                        </td>
                    </tr>
                    <tr>
                        <td  class="bookletKeyColumn">Current value</td>
                        <td>
                            <xsl:if test="currentValue">
                                <xsl:variable name="currentValueVar" select="currentValue" />
                                $<xsl:value-of select='format-number($currentValueVar, "#,###,###.00")' />
                            </xsl:if>
                        </td>
                        <td  class="bookletKeyColumn">Current units</td>
                        <td>
                            <xsl:value-of select="currentUnits" />
                        </td>
                    </tr>
                    <tr>
                        <td  class="bookletKeyColumn">Centrelink deductible amount</td>
                        <td>
                            <xsl:if test="centreLinksDeductibleAmount">
                                <xsl:variable name="centreLinksDeductibleAmountVar" select="centreLinksDeductibleAmount" />
                                $<xsl:value-of select='format-number($centreLinksDeductibleAmountVar, "#,###,###.00")' />
                            </xsl:if>
                        </td>
                        <td  class="bookletKeyColumn">Tax free component1</td>
                        <td>
                            <xsl:if test="taxFreeComponent">
                                <xsl:variable name="taxFreeComponentVar" select="taxFreeComponent" />
                                $<xsl:value-of select='format-number($taxFreeComponentVar, "#,###,###.00")' />
                            </xsl:if>
                        </td>
                    </tr>
                    <tr>
                        <td  class="bookletKeyColumn">Taxable component</td>
                        <td>
                            <xsl:if test="taxableComponent">
                                <xsl:variable name="taxableComponentVar" select="taxableComponent" />
                                $<xsl:value-of select='format-number($taxableComponentVar, "#,###,###.00")' />
                            </xsl:if>
                        </td>
                        <td  class="bookletKeyColumn">Income p.a.</td>
                        <td>
                            <xsl:if test="income">
                                <xsl:variable name="incomeVar" select="income" />
                                $<xsl:value-of select='format-number($incomeVar, "#,###,###.00")' />
                            </xsl:if>
                        </td>
                    </tr>
                    <tr>
                        <td  class="bookletKeyColumn">Indicate min/max/specified</td>
                        <td><xsl:value-of select="minMaxSpecified" /></td>
                        <td  class="bookletKeyColumn">Payment frequency</td>
                        <td><xsl:value-of select="paymentFrequency" /></td>
                    </tr>
                    <tr>
                        <td  class="bookletKeyColumn">Term of pension annuity</td>
                        <td><xsl:value-of select="termOfPensionAnnuity" /></td>
                        <td  class="bookletKeyColumn">Index</td>
                        <td>
                            <xsl:call-template name="yesNoTemplate">
                                <xsl:with-param name="boolValue" select="indexed/text()" />
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <td  class="bookletKeyColumn">Indexation Rate</td>
                        <td>
                            <xsl:if test="indexationRate">
                                <xsl:variable name="indexationRateVar" select="indexationRate" />
                                <xsl:value-of select='format-number($indexationRateVar, "#,###,###.00")' /> %
                            </xsl:if>
                        </td>
                        <td  class="bookletKeyColumn">Residuary capital value</td>
                        <td>
                            <xsl:if test="residuaryCapitalValue">
                                <xsl:variable name="residuaryCapitalValueVar" select="residuaryCapitalValue" />
                                $<xsl:value-of select='format-number($residuaryCapitalValueVar, "#,###,###.00")' />
                            </xsl:if>
                        </td>
                    </tr>
                    <tr>
                        <td  class="bookletKeyColumn">Reversionary</td>
                        <td>
                            <xsl:call-template name="yesNoTemplate">
                                <xsl:with-param name="boolValue" select="reversionary/text()" />
                            </xsl:call-template>
                        </td>
                        <td  class="bookletKeyColumn">Death benefit nomination</td>
                        <td>
                            <xsl:call-template name="yesNoTemplate">
                                <xsl:with-param name="boolValue" select="deathBenefitNomination/text()" />
                            </xsl:call-template>
                        </td>
                    </tr>
                </xsl:for-each>


                <tr>
                </tr>
            </tbody>
        </table>

        <!--
		<table class="bookletTable">
			<tbody>
				<tr class="bookletRowTallyHeader">
					<td></td>
					<td>1</td>
					<td>2</td>
					<td>3</td>
					<td>4</td>
				</tr>
				<xsl:for-each select="$tableDefinitions/tables/table[@name='IncomeStream']/tr" >
					<xsl:variable name="customerNode" select="@node" />
					<tr>
						<xsl:copy-of select="td" />
						<td class="bookletTallyCell">
							<xsl:call-template name="printNodeValue">
								<xsl:with-param name="theNode" select="$incomeStreams/item[position() = 1]/*[local-name() = $customerNode]" />
							</xsl:call-template>
						</td>
						<td class="bookletTallyCell">
							<xsl:call-template name="printNodeValue">
								<xsl:with-param name="theNode" select="$incomeStreams/item[position() = 2]/*[local-name() = $customerNode]" />
							</xsl:call-template>
						</td>
						<td class="bookletTallyCell">
							<xsl:call-template name="printNodeValue">
								<xsl:with-param name="theNode" select="$incomeStreams/item[position() = 3]/*[local-name() = $customerNode]" />
							</xsl:call-template>
						</td>
						<td class="bookletTallyCell">
							<xsl:call-template name="printNodeValue">
								<xsl:with-param name="theNode" select="$incomeStreams/item[position() = 4]/*[local-name() = $customerNode]" />
							</xsl:call-template>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
		-->
    </xsl:template>

    <!--
		Summary table for whether any of the customers have received early payments.
	-->
    <xsl:template match="/variable/superannuation/redundancyEarlyRetirementPayments">
        <h3>Redundancy or Early Retirement Payment</h3>

        <!-- Added this section to handle multiple clients -->

        <table class="bookletTable">
            <tbody>
                <tr class="bookletRowTallyHeader">
                    <td>Have you, or will you expect to receive a Redundancy or Early Retirement Payment?</td>
                    <td>Employment commencement date</td>
                    <td>Date employment to cease</td>
                    <td>Amount of redundancy / early retirement payment</td>
                    <td>Payment for unused annual leave</td>
                    <td>Payment for unused long service leave</td>
                    <td>Will you have to exit the superannuation fund?</td>
                </tr>
                <xsl:for-each select="item">
                    <tr>
                        <td>
                            <xsl:call-template name="yesNoTemplate">
                                <xsl:with-param name="boolValue" select="expectToReceive/text()" />
                            </xsl:call-template>
                        </td>
                        <td><!--<xsl:value-of select="employmentCommencementDate" />-->
                            <xsl:call-template name="formatTWDate" >
                                <xsl:with-param name="dateValue" select="employmentCommencementDate" />
                            </xsl:call-template>
                        </td>
                        <td><!--<xsl:value-of select="dateEmploymentToCease" />-->
                            <xsl:call-template name="formatTWDate" >
                                <xsl:with-param name="dateValue" select="dateEmploymentToCease" />
                            </xsl:call-template>
                        </td>
                        <td align="right">
                            <xsl:if test="earlyRetirementPaymentAmount">
                                <xsl:variable name="earlyRetirementPaymentAmount" select="earlyRetirementPaymentAmount" />
                                $<xsl:value-of select='format-number($earlyRetirementPaymentAmount, "#,###,###.00")' />
                            </xsl:if>
                        </td>
                        <td align="right">
                            <xsl:if test="paymentForUnusedAnnualLeave">
                                <xsl:variable name="paymentForUnusedAnnualLeave" select="paymentForUnusedAnnualLeave" />
                                $<xsl:value-of select='format-number($paymentForUnusedAnnualLeave, "#,###,###.00")' />
                            </xsl:if>
                        </td>
                        <td align="right">
                            <xsl:if test="paymentForUnusedLongServiceLeave">
                                <xsl:variable name="paymentForUnusedLongServiceLeave" select="paymentForUnusedLongServiceLeave" />
                                $<xsl:value-of select='format-number($paymentForUnusedLongServiceLeave, "#,###,###.00")' />
                            </xsl:if>
                        </td>
                        <td>
                            <xsl:call-template name="yesNoTemplate">
                                <xsl:with-param name="boolValue" select="exitSuperannuationFund/text()" />
                            </xsl:call-template>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>


        <!--
		// TODO Fix this to use the owner query once the owner is stored on the redundancyEarlyRetirementPayments/item
		<xsl:variable name="customer1Retirement" select="$earlyRetirement/item[owner/text() = $customer1]" />
		<xsl:variable name="customer2Retirement" select="$earlyRetirement/item[owner/text() = $customer2]" />
		-->
        <!-- Remove this section from August code to handle multiple clients
		<xsl:variable name="customer1Retirement" select="item[position() = 1]" />
		<xsl:variable name="customer2Retirement" select="item[position() = 2]" />

		<h3>Redundancy or Early Retirement Payment</h3>
		<p>Have you, or will you expect to receive a Redundancy or Early Retirement Payment?
			<b>
				<xsl:choose>
					<xsl:when test="$customer1Retirement[expectToReceive/text() = 'true'] or $customer2Retirement[expectToReceive/text() = 'true']">Yes</xsl:when>
					<xsl:otherwise>No</xsl:otherwise>
				</xsl:choose>
			</b>
		</p>
		<br/>
		<table class="bookletTable">
			<tbody>
				<tr class="bookletRowTallyHeader">
					<td class="bookletHeaderNotTallyCell">Service period</td>
					<td>Customer 1</td>
					<td>Customer 2</td>
				</tr>
				<xsl:for-each select="$tableDefinitions/tables/table[@name='EarlyRetirement']/tr" >
					<xsl:variable name="customerNode" select="@node" />
					<tr>
						<xsl:copy-of select="td" />
						<td class="bookletTallyCell">
							<xsl:call-template name="printNodeValue">
								<xsl:with-param name="theNode" select="$customer1Retirement/*[local-name() = $customerNode]" />
							</xsl:call-template>
						</td>
						<td class="bookletTallyCell">
							<xsl:call-template name="printNodeValue">
								<xsl:with-param name="theNode" select="$customer2Retirement/*[local-name() = $customerNode]" />
							</xsl:call-template>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
		-->
    </xsl:template>

    <!--
		Print out all the insurance recorded for the plan.
	-->
    <xsl:template match="/variable/insurance">
        <h2>Insurance</h2>
        <xsl:apply-templates select="personalInsurance" />
        <xsl:apply-templates select="assets" />
        <xsl:apply-templates select="incomeProtection" />
    </xsl:template>

    <!--
		Print out all the personal insurance.
	-->
    <xsl:template match="/variable/insurance/personalInsurance">
        <h4>Current personal insurance (term life cover, total &amp; permanent disability (TPD), trauma, whole of life or endowment)</h4>
        <table class="bookletTable">
            <tbody>
                <tr class="bookletRowTallyHeader">
                    <td>Provider</td>
                    <td>Type</td>
                    <td>Life insured</td>
                    <td>Owner / beneficiary</td>
                    <td>Cover level ($)</td>
                    <td>Annual premium ($)</td>
                    <td>Surrender value (if any) ($)</td>
                    <td>Maturity value (if any) ($)</td>
                    <td>TPD definition - own /any / home duties / general</td>
                    <td>Inside / outside super</td>
                    <td>Retain</td>
                </tr>
                <xsl:for-each select="item">
                    <tr>
                        <td class="bookletTallyCell"><xsl:value-of select="provider" /></td>
                        <td class="bookletTallyCell"><xsl:value-of select="type" /></td>
                        <td class="bookletTallyCell"><xsl:value-of select="lifeInsured" /></td>
                        <td class="bookletTallyCell"><xsl:value-of select="owner" /></td>
                        <td class="bookletTallyCell">
                            <xsl:call-template name="printNodeValue">
                                <xsl:with-param name="theNode" select="coverLevel" />
                            </xsl:call-template>
                        </td>
                        <td class="bookletTallyCell">
                            <xsl:call-template name="printNodeValue">
                                <xsl:with-param name="theNode" select="annualPremium" />
                            </xsl:call-template>
                        </td>
                        <td class="bookletTallyCell">
                            <xsl:call-template name="printNodeValue">
                                <xsl:with-param name="theNode" select="surrenderValue" />
                            </xsl:call-template>
                        </td>
                        <td class="bookletTallyCell">
                            <xsl:call-template name="printNodeValue">
                                <xsl:with-param name="theNode" select="maturityValue" />
                            </xsl:call-template>
                        </td>
                        <td class="bookletTallyCell"><xsl:value-of select="TPDDefinition" /></td>
                        <td class="bookletTallyCell">
                            <xsl:choose>
                                <xsl:when test="insideSuper/text() = 'true'">Inside</xsl:when>
                                <xsl:otherwise>Outside</xsl:otherwise>
                            </xsl:choose>
                        </td>
                        <td class="bookletTallyCell">
                            <xsl:call-template name="printNodeValue">
                                <xsl:with-param name="theNode" select="retain" />
                            </xsl:call-template>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>

    <!--
		Print out all the assets for the insurance.
	-->
    <xsl:template match="/variable/insurance/assets">
        <h4>What existing assets would be realised (fully and/or partially) in the event of death/TPD/trauma?</h4>
        <table class="bookletTable">
            <tbody>
                <tr class="bookletRowTallyHeader">
                    <td>Asset</td>
                    <td>Amount ($)</td>
                    <td>Owner</td>
                    <td>Death</td>
                    <td>TPD</td>
                    <td>Trauma</td>
                </tr>
                <xsl:for-each select="item">
                    <tr>
                        <td class="bookletTallyCell"><xsl:value-of select="asset" /></td>
                        <td class="bookletTallyCell">
                            <xsl:call-template name="printNodeValue">
                                <xsl:with-param name="theNode" select="amount" />
                            </xsl:call-template>
                        </td>
                        <td class="bookletTallyCell"><xsl:value-of select="owner" /></td>
                        <td class="bookletTallyCell"><xsl:value-of select="death" /></td>
                        <td class="bookletTallyCell"><xsl:value-of select="TPD" /></td>
                        <td class="bookletTallyCell"><xsl:value-of select="trauma" /></td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>

    <!--
		Print out all the income protection policies.
	-->
    <xsl:template match="/variable/insurance/incomeProtection">
        <h4>Current income protection or salary continuance insurance</h4>
        <table class="bookletTable">
            <tbody>
                <tr class="bookletRowTallyHeader">
                    <td>Provider</td>
                    <td>Owner</td>
                    <td>Agreed or indemnity value ($)</td>
                    <td>Monthly benefit ($)</td>
                    <td>Annual premium ($)</td>
                    <td>Waiting period</td>
                    <td>Retain</td>
                    <td>Inside or outside super</td>
                    <td>Benefit payment period</td>
                </tr>
                <xsl:for-each select="item">
                    <tr>
                        <td class="bookletTallyCell"><xsl:value-of select="provider" /></td>
                        <td class="bookletTallyCell"><xsl:value-of select="owner" /></td>
                        <td class="bookletTallyCell">
                            <xsl:call-template name="printNodeValue">
                                <xsl:with-param name="theNode" select="value" />
                            </xsl:call-template>
                        </td>
                        <td class="bookletTallyCell">
                            <xsl:call-template name="printNodeValue">
                                <xsl:with-param name="theNode" select="monthlyBenefit" />
                            </xsl:call-template>
                        </td>
                        <td class="bookletTallyCell">
                            <xsl:call-template name="printNodeValue">
                                <xsl:with-param name="theNode" select="annualPremium" />
                            </xsl:call-template>
                        </td>
                        <td class="bookletTallyCell"><xsl:value-of select="waitingPeriod" /></td>
                        <td class="bookletTallyCell">
                            <xsl:call-template name="printNodeValue">
                                <xsl:with-param name="theNode" select="retain" />
                            </xsl:call-template>
                        </td>
                        <td class="bookletTallyCell">
                            <xsl:choose>
                                <xsl:when test="insideSuper/text() = 'true'">Inside</xsl:when>
                                <xsl:otherwise>Outside</xsl:otherwise>
                            </xsl:choose>
                        </td>
                        <td class="bookletTallyCell"><xsl:value-of select="benefitPaymentPeriod" /></td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>

    <!--
		Print out all the replacement checklists.
	-->
    <xsl:template match="/variable/clientAuthorisation">
        <xsl:apply-templates select="item[productCategory/text() = 'Investment']" />
        <xsl:apply-templates select="item[productCategory/text() = 'Insurance']" />
        <xsl:apply-templates select="item[productCategory/text() = 'Superannuation/Pension']" />
    </xsl:template>

    <!--
		Print out all the manual checklists.
	-->
    <xsl:template match="/variable/manualChecklist">
        <h2>Preparation Checklists from Create Advice Strategies Step</h2>
        <table class="bookletTable">
            <tr class="bookletRowHeader">
                <td>Description</td>
                <td>Result</td>
                <td>Completed By</td>
                <td>Completed Date</td>
            </tr>
            <xsl:for-each select="item">
                <xsl:if test="processStep/text() = 'Create Advice Strategies'">
                    <tr>
                        <td><xsl:value-of select="descriptionForUser/text()" /></td>
                        <td><xsl:value-of select="result/text()" /></td>
                        <td><xsl:value-of select="completedBy/text()" /></td>
                        <td><xsl:value-of select="completedDate/text()" /></td>
                    </tr>
                </xsl:if>
            </xsl:for-each>
        </table>
    </xsl:template>

    <!--
		Print out all the file note.
	-->
    <xsl:template match="/variable/fileNote">
        <h2>File Notes</h2>
        <table class="bookletTable">
            <xsl:for-each select="item">
                <tr>
                    <td class="bookletStrongKeyColumn">Subject</td>
                    <td colspan="3"><xsl:value-of select="subject/text()" /></td>
                </tr>
                <tr>
                    <td class="bookletStrongKeyColumn">Customer</td>
                    <td colspan="3"><xsl:value-of select="customer/text()" /></td>
                </tr>
                <tr>
                    <td class="bookletKeyColumn">File Note Event</td>
                    <td><xsl:value-of select="fileNoteEvent/text()" /></td>
                    <td class="bookletKeyColumn">Contact Date</td>
                    <td><xsl:value-of select="dateOfContact/text()" /></td>
                </tr>
                <tr>
                    <td class="bookletKeyColumn">Contact Initiated By</td>
                    <td><xsl:value-of select="contactInitiatedBy/text()" /></td>
                    <td class="bookletKeyColumn">Start/End Time</td>
                    <td><xsl:value-of select="startTime/text()" />  -  <xsl:value-of select="endTime/text()" /></td>
                </tr>
                <tr>
                    <td class="bookletKeyColumn">Method of Contact</td>
                    <td><xsl:value-of select="methodOfContact/text()" /></td>
                    <td class="bookletKeyColumn">People Involved/Present</td>
                    <td><xsl:value-of select="peopleInvolvedAndOrPresent/text()" /></td>
                </tr>
                <tr>
                    <td class="bookletKeyColumn">Note</td>
                    <td colspan="3"><xsl:value-of select="note/text()" disable-output-escaping="yes"/></td>
                </tr>
                <tr class="bookletRowHeader">
                    <td>Best Interest</td>
                    <td colspan="3">Comments</td>
                </tr>

                <xsl:for-each select="safeHarbourSteps/item">
                    <tr>
                        <td>
                            <xsl:call-template name="yesNoTemplate">
                                <xsl:with-param name="boolValue" select="isCompleted/text()" />
                            </xsl:call-template>
                        </td>
                        <td colspan="3">
                            <xsl:value-of select="stepDescription/text()" />
                            <br />
                            <xsl:value-of select="comments/text()" />
                        </td>
                    </tr>
                </xsl:for-each>

            </xsl:for-each>
        </table>
    </xsl:template>

    <xsl:template name="printLinkedChecklists" >
        <xsl:param name="description" />
        <table class="bookletTable">
            <tbody>
                <tr class="bookletRowHeader">
                    <td>Linked Replacement Checklists</td>
                </tr>
                <xsl:for-each select="/variable/replacementChecklistLinks/item">
                    <xsl:if test="name/text() = $description">
                        <tr>
                            <td class=""><xsl:value-of select="value/text()"/></td>
                        </tr>
                    </xsl:if>
                </xsl:for-each>
            </tbody>
        </table>
        <br/>
    </xsl:template>

    <!--
		Prints the investment replacement checklist
	-->
    <xsl:template match="/variable/clientAuthorisation/item[productCategory/text() = 'Investment']">
        <!--<div class="page-break" />-->
        <div class="page-break"> - </div>
        <h2>Investment Replacement Checklist (<xsl:value-of select="description/text()"/>)</h2>
        <xsl:call-template name="printLinkedChecklists">
            <xsl:with-param name="description" select="description" />
        </xsl:call-template>
        <xsl:call-template name="investmentReplacementCheckListInvestmentDetails" />
        <xsl:call-template name="genericUnderlyingInvestmentDetails" />
        <xsl:call-template name="genericReplacementChecklistFeesRows">
            <xsl:with-param name="tableHeadingName">Fees</xsl:with-param>
            <xsl:with-param name="tableDefinitionName">InvestmentReplacementChecklistFeesTable</xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="genericReplacementCheckListAssetAllocation" />
        <xsl:call-template name="genericReplacementCheckListProductFeatures" />
        <xsl:call-template name="investmentReplaceChecklistResultInRows" />
        <xsl:apply-templates select="checklistQuickPlanInvest" />
        <xsl:call-template name="printBenefitsJustifications">
            <xsl:with-param name="theText" select="justification/Details" />
            <xsl:with-param name="type">Investment</xsl:with-param>
            <xsl:with-param name="unableToAccessInfoFlag" select="justification/unableToAccessInfoFlag" />
            <xsl:with-param name="Notes" select="justification/Notes" />
        </xsl:call-template>
        <xsl:call-template name="printNotes">
            <xsl:with-param name="theText" select="justification/Notes" />
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="investmentReplacementCheckListInvestmentDetails">
        <table class="bookletTable">
            <tr class="bookletRowHeader">
                <td>Investment Details</td>
                <td>Current</td>
                <td>Proposed</td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Investment Provider</td>
                <td><xsl:value-of select="currentInvestmentDetails/investmentProvider" /></td>
                <td><xsl:value-of select="proposedInvestmentDetails/investmentProvider" /></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Product name</td>
                <td><xsl:value-of select="currentInvestmentDetails/productName" /></td>
                <td><xsl:value-of select="proposedInvestmentDetails/productName" /></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Product Number</td>
                <td>
                    <xsl:value-of select="currentInvestmentDetails/productNumber" />
                </td>
                <td>
                    <xsl:value-of select="proposedInvestmentDetails/productNumber" />
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Product Owner(s)</td>
                <td>
                    <xsl:call-template name="printClientListItemForRC">
                        <xsl:with-param name="clientListItem" select="currentInvestmentDetails/productOwners" />
                        <xsl:with-param name="otherFlag" select="currentInvestmentDetails/otherProductOwnersFlag" />
                        <xsl:with-param name="otherDesc" select="currentInvestmentDetails/otherProductOwners" />
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name="printClientListItemForRC">
                        <xsl:with-param name="clientListItem" select="proposedInvestmentDetails/productOwners" />
                        <xsl:with-param name="otherFlag" select="proposedInvestmentDetails/otherProductOwnersFlag" />
                        <xsl:with-param name="otherDesc" select="proposedInvestmentDetails/otherProductOwners" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Type of fund</td>
                <td><xsl:value-of select="currentInvestmentDetails/fundType" /></td>
                <td><xsl:value-of select="proposedInvestmentDetails/fundType" /></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Commencement date</td>
                <td>
                    <xsl:call-template name="formatTWDate" >
                        <xsl:with-param name="dateValue" select="currentInvestmentDetails/commencementDate" />
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name="formatTWDate" >
                        <xsl:with-param name="dateValue" select="proposedInvestmentDetails/commencementDate" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Regular Savings Plan</td>
                <td>
                    $<xsl:call-template name="formatUnit">
                    <xsl:with-param name="unitValue" select="currentInvestmentDetails/regularSavingAmount" />
                </xsl:call-template>
                    - <xsl:value-of select="currentInvestmentDetails/regularSavingFrequency" />
                </td>
                <td>
                    $<xsl:call-template name="formatUnit">
                    <xsl:with-param name="unitValue" select="proposedInvestmentDetails/regularSavingAmount" />
                </xsl:call-template>
                    - <xsl:value-of select="proposedInvestmentDetails/regularSavingFrequency" />
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Balance</td>
                <!--
				<td>$<xsl:value-of select="currentInvestmentDetails/currentBalance" /></td>
				<td>$<xsl:value-of select="proposedInvestmentDetails/currentBalance" /></td>
				-->

                <td>$
                    <xsl:call-template name="formatUnit" >
                        <xsl:with-param name="unitValue" select="currentInvestmentDetails/currentBalance" />
                    </xsl:call-template>
                    <xsl:value-of select="currentInvestmentDetails/currentBalance" />
                </td>
                <td>$
                    <xsl:call-template name="formatUnit" >
                        <xsl:with-param name="unitValue" select="proposedInvestmentDetails/currentBalance" />
                    </xsl:call-template>
                </td>

            </tr>
        </table>
    </xsl:template>

    <!--
		Prints out the fees rows for all the known ones and others.
	-->
    <!--
	<xsl:template name="investmentReplaceChecklistFeesRows" >
		<tr>
			<td class="bookletStrongKeyColumn" colspan="3">Fees ($ amount /% .pa.)</td>
		</tr>
		<xsl:variable name="currentFees" select="currentFeeDetails" />
		<xsl:variable name="proposedFees" select="proposedFeeDetails" />
		<xsl:for-each select="$tableDefinitions/tables/table[@name='ReplacementChecklistFeesTable']/tr" >
			<xsl:variable name="feeName" select="@node" />
			<tr>
				<xsl:copy-of select="td" />
				<td><xsl:value-of select="$currentFees/item[feeType/text() = $feeName]/feeValue" /></td>
				<td><xsl:value-of select="$proposedFees/item[feeType/text() = $feeName]/feeValue" /></td>
			</tr>
		</xsl:for-each>
		
		<xsl:variable name="otherNames" select="distinct-values($currentFees/item[not(feeType/text() = $tableDefinitions/tables/table[@name='ReplacementChecklistFeesTable']/tr[@node])]/feeType
					| $proposedFees/item[not(feeType/text() = $tableDefinitions/tables/table[@name='ReplacementChecklistFeesTable']/tr[@node])]/feeType)" />
		<xsl:for-each select="$otherNames">
			<xsl:variable name="otherFeeName" select="." />
			<tr>
				<td class="bookletKeyColumn">Other - <xsl:value-of select="$otherFeeName" /></td>
				<td><xsl:value-of select="$currentFees/item[feeType/text() = $otherFeeName]/feeValue" /></td>
				<td><xsl:value-of select="$proposedFees/item[feeType/text() = $otherFeeName]/feeValue" /></td>
			</tr>
		</xsl:for-each>
	</xsl:template>
	-->

    <!--
		Prints out the replacement results
	-->
    <xsl:template name="investmentReplaceChecklistResultInRows" >
        <br/>
        <table class="bookletTable">
            <tr>
                <td class="bookletStrongKeyColumn" colspan="3">Will the replacement result in:</td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Duplication of entry fees (p.a.)</td>
                <xsl:call-template name="printInvestmentReplacement" >
                    <xsl:with-param name="flagNode" select="investmentResultDetails/feeDuplicationFlag" />
                    <xsl:with-param name="valueNode" select="investmentResultDetails/feeDuplicationValue" />
                </xsl:call-template>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Capital loss on initial investment</td>
                <xsl:call-template name="printInvestmentReplacement" >
                    <xsl:with-param name="flagNode" select="investmentResultDetails/capitalLossFlag" />
                    <xsl:with-param name="valueNode" select="investmentResultDetails/capitalLossValue" />
                </xsl:call-template>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Capital gains tax liability</td>
                <xsl:call-template name="printInvestmentReplacement" >
                    <xsl:with-param name="flagNode" select="investmentResultDetails/capitalGainsFlag" />
                    <xsl:with-param name="valueNode" select="investmentResultDetails/capitalGainsValue" />
                </xsl:call-template>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Loss of taxation benefit - break of 125% contribution rule (Insurance Bonds)</td>
                <xsl:call-template name="printInvestmentReplacement" >
                    <xsl:with-param name="flagNode" select="investmentResultDetails/lossOfTaxBenefitFlag" />
                    <xsl:with-param name="valueNode" select="investmentResultDetails/lossOfTaxBenefitValue" />
                </xsl:call-template>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Any other taxation implications</td>
                <xsl:call-template name="printInvestmentReplacement" >
                    <xsl:with-param name="flagNode" select="investmentResultDetails/otherTaxImplicationsFlag" />
                    <xsl:with-param name="valueNode" select="investmentResultDetails/otherTaxImplicationsValue" />
                </xsl:call-template>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Adjustment to Centrelink benefits</td>
                <xsl:call-template name="printInvestmentReplacement" >
                    <xsl:with-param name="flagNode" select="investmentResultDetails/adjustBenefitsFlag" />
                    <xsl:with-param name="valueNode" select="investmentResultDetails/adjustBenefitsValue" />
                </xsl:call-template>
            </tr>
        </table>
    </xsl:template>

    <!--
		Prints out the Yes/No answer and when 'Yes' prints the trailing money value.
	-->
    <xsl:template name="printInvestmentReplacement" >
        <xsl:param name="flagNode" />
        <xsl:param name="valueNode" />
        <td colspan="2">
            <xsl:call-template name="printNodeValue">
                <xsl:with-param name="theNode" select="$flagNode" />
            </xsl:call-template>
            <xsl:if test="$flagNode/text() = 'true'">
                -
                <xsl:call-template name="printNodeValue">
                    <xsl:with-param name="theNode" select="$valueNode" />
                </xsl:call-template>
            </xsl:if>
        </td>
    </xsl:template>

    <!--
		Prints the insurance replacement checklist
	-->
    <xsl:template match="/variable/clientAuthorisation/item[productCategory/text() = 'Insurance']">
        <div class="page-break"> - </div>
        <h2>Insurance Replacement Checklist (<xsl:value-of select="description/text()"/>)</h2>
        <xsl:call-template name="printLinkedChecklists">
            <xsl:with-param name="description" select="description" />
        </xsl:call-template>
        <xsl:call-template name="insuranceReplacementChecklistInsuranceDetails" />
        <xsl:apply-templates select="checklistQuickPlanInsurance" />
        <xsl:call-template name="printBenefitsJustifications">
            <xsl:with-param name="theText" select="justification/Details" />
            <xsl:with-param name="type">Insurance</xsl:with-param>
            <xsl:with-param name="unableToAccessInfoFlag" select="justification/unableToAccessInfoFlag" />
            <xsl:with-param name="Notes" select="justification/Notes" />
        </xsl:call-template>
        <xsl:call-template name="printNotes">
            <xsl:with-param name="theText" select="justification/Notes" />
        </xsl:call-template>
    </xsl:template>

    <!--
	-->
    <xsl:template name="insuranceReplacementChecklistInsuranceDetails">
        <table class="bookletTable">
            <tr class="bookletRowTallyHeader">
                <td>Insurance Details</td>
                <td>Current</td>
                <td>Proposed</td>
            </tr>
            <xsl:call-template name="insuranceReplacementChecklistInsuranceDetailsGeneral" />
        </table>
        <br />
        <table class="bookletTable">
            <xsl:call-template name="insuranceReplacementChecklistInsuranceTypeAndSumInsured" />
        </table>
        <br />
        <table class="bookletTable">
            <xsl:call-template name="insuranceReplacementChecklistInsuranceResultDetails" />
        </table>
    </xsl:template>

    <!--
		Print out the general proposed and current details.
	-->
    <xsl:template name="insuranceReplacementChecklistInsuranceDetailsGeneral">
        <tr>
            <td class="bookletKeyColumn">Insurance Provider</td>
            <td><xsl:value-of select="currentInsuranceDetails/insuranceProvider" /></td>
            <td><xsl:value-of select="proposedInsuranceDetails/insuranceProvider" /></td>
        </tr>
        <tr>
            <td class="bookletKeyColumn">Policy name</td>
            <td><xsl:value-of select="currentInsuranceDetails/productName" /></td>
            <td><xsl:value-of select="proposedInsuranceDetails/productName" /></td>
        </tr>
        <tr>
            <td class="bookletKeyColumn">Policy number</td>
            <td>
                <xsl:value-of select="currentInsuranceDetails/productNumber" />
            </td>
            <td>
                <xsl:value-of select="proposedInsuranceDetails/productNumber" />
            </td>
        </tr>

        <tr>
            <td class="bookletKeyColumn">Policy Owner(s)</td>
            <td>
                <xsl:call-template name="printClientListItemForRC">
                    <xsl:with-param name="clientListItem" select="currentInsuranceDetails/productOwners" />
                    <xsl:with-param name="otherFlag" select="currentInsuranceDetails/otherProductOwnersFlag" />
                    <xsl:with-param name="otherDesc" select="currentInsuranceDetails/otherProductOwners" />
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="printClientListItemForRC">
                    <xsl:with-param name="clientListItem" select="proposedInsuranceDetails/productOwners" />
                    <xsl:with-param name="otherFlag" select="proposedInsuranceDetails/otherProductOwnersFlag" />
                    <xsl:with-param name="otherDesc" select="proposedInsuranceDetails/otherProductOwners" />
                </xsl:call-template>
            </td>
        </tr>

        <tr>
            <!--
			<td class="bookletKeyColumn">Type of cover</td>
			<td><xsl:value-of select="currentInsuranceDetails/coverType" /></td>
			<td><xsl:value-of select="proposedInsuranceDetails/coverType" /></td>
			-->
            <td class="bookletKeyColumn">Structure Type</td>
            <td>
                <ul>
                    <xsl:if test="currentInsuranceDetails/coverTypeSuperFlag = 'true'"><li>Super</li></xsl:if>
                    <xsl:if test="currentInsuranceDetails/coverTypeOrdinaryFlag = 'true'"><li>Ordinary</li></xsl:if>
                </ul>
            </td>
            <td>
                <ul>
                    <xsl:if test="proposedInsuranceDetails/coverTypeSuperFlag = 'true'"><li>Super</li></xsl:if>
                    <xsl:if test="proposedInsuranceDetails/coverTypeOrdinaryFlag = 'true'"><li>Ordinary</li></xsl:if>
                </ul>
            </td>
        </tr>
        <tr>
            <td class="bookletKeyColumn">Life insured</td>
            <td>
                <!--
				<xsl:call-template name="yesNoTemplate">
					<xsl:with-param name="boolValue" select="currentInsuranceDetails/lifeInsuredFlag" />
				</xsl:call-template>
				-->

                <xsl:call-template name="printClientListItemForRC">
                    <xsl:with-param name="clientListItem" select="currentInsuranceDetails/lifeInsured" />
                    <xsl:with-param name="otherFlag" select="currentInsuranceDetails/otherLifeInsuredFlag" />
                    <xsl:with-param name="otherDesc" select="currentInsuranceDetails/otherLifeInsured" />
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="printClientListItemForRC">
                    <xsl:with-param name="clientListItem" select="proposedInsuranceDetails/lifeInsured" />
                    <xsl:with-param name="otherFlag" select="proposedInsuranceDetails/otherLifeInsuredFlag" />
                    <xsl:with-param name="otherDesc" select="proposedInsuranceDetails/otherLifeInsured" />
                </xsl:call-template>
                <!--
				<xsl:call-template name="yesNoTemplate">
					<xsl:with-param name="boolValue" select="proposedInsuranceDetails/lifeInsuredFlag" />
				</xsl:call-template>
				-->
            </td>
        </tr>
        <tr>
            <td class="bookletKeyColumn">Commencement date</td>
            <td>
                <xsl:call-template name="formatTWDate" >
                    <xsl:with-param name="dateValue" select="currentInsuranceDetails/commencementDate" />
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="formatTWDate" >
                    <xsl:with-param name="dateValue" select="proposedInsuranceDetails/commencementDate" />
                </xsl:call-template>
            </td>
        </tr>
        <tr>
            <td class="bookletKeyColumn">Name of underwriter</td>
            <td><xsl:value-of select="currentInsuranceDetails/underwriterName" /></td>
            <td><xsl:value-of select="proposedInsuranceDetails/underwriterName" /></td>
        </tr>
    </xsl:template>

    <xsl:template name="printClientListItemForRC">
        <xsl:param name="clientListItem" />
        <xsl:param name="otherFlag" />
        <xsl:param name="otherDesc" />

        <xsl:for-each select="$clientListItem/item">
            <xsl:if test="position() > 1"><br/></xsl:if>
            <xsl:if test="isSelected = 'true'">
                <xsl:value-of select="label" />
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="$otherFlag = 'true' ">
            <br/>Other - <xsl:value-of select="$otherDesc" />
        </xsl:if>

    </xsl:template>
    <!--
		Print out the general proposed and current details.
	-->
    <xsl:template name="insuranceReplacementChecklistInsuranceTypeAndSumInsured">
        <tr>
            <td class="bookletStrongKeyColumn" colspan="3">Type &amp; Sum Insured:</td>
        </tr>
        <tr>
            <td class="bookletKeyColumn">Term Life</td>
            <td>$
                <xsl:call-template name="formatUnit" >
                    <xsl:with-param name="unitValue" select="currentInsuranceSumDetails/deathCoverValue" />
                </xsl:call-template>

                <xsl:if test="currentInsuranceSumDetails/accidentalDeathFlag = 'true'">
                    (Accidental Death)
                </xsl:if>
            </td>
            <td>$
                <xsl:call-template name="formatUnit" >
                    <xsl:with-param name="unitValue" select="proposedInsuranceSumDetails/deathCoverValue" />
                </xsl:call-template>
                <xsl:if test="proposedInsuranceSumDetails/accidentalDeathFlag = 'true'">
                    (Accidental Death)
                </xsl:if>
            </td>
        </tr>
        <tr>
            <td class="bookletKeyColumn">TPD</td>
            <td>$
                <xsl:call-template name="formatUnit" >
                    <xsl:with-param name="unitValue" select="currentInsuranceSumDetails/TpdCoverValue" />
                </xsl:call-template>

                <xsl:if test="string-length(currentInsuranceSumDetails/TpdCoverType) > 0" >
                    (<xsl:value-of select="currentInsuranceSumDetails/TpdCoverType" />)
                </xsl:if>
            </td>
            <td>$
                <xsl:call-template name="formatUnit" >
                    <xsl:with-param name="unitValue" select="proposedInsuranceSumDetails/TpdCoverValue" />
                </xsl:call-template>
                <xsl:if test="string-length(proposedInsuranceSumDetails/TpdCoverType) > 0" >
                    (<xsl:value-of select="proposedInsuranceSumDetails/TpdCoverType" />)
                </xsl:if>
            </td>
        </tr>
        <tr>
            <td class="bookletKeyColumn">Trauma</td>
            <td>$<xsl:value-of select="currentInsuranceSumDetails/TraumaCoverValue" /></td>
            <td>$<xsl:value-of select="proposedInsuranceSumDetails/TraumaCoverValue" /></td>
        </tr>
        <tr>
            <td class="bookletKeyColumn">Income Protection</td>
            <xsl:call-template name="insuranceReplacementChecklistInsuranceIncomeProtectionCell">
                <xsl:with-param name="theNode" select="currentInsuranceSumDetails" />
            </xsl:call-template>
            <xsl:call-template name="insuranceReplacementChecklistInsuranceIncomeProtectionCell">
                <xsl:with-param name="theNode" select="proposedInsuranceSumDetails" />
            </xsl:call-template>
        </tr>
        <tr>
            <td class="bookletKeyColumn">Premium Structure</td>
            <xsl:call-template name="insuranceReplacementChecklistInsurancePremiumTypeCell">
                <xsl:with-param name="theNode" select="currentInsuranceSumDetails" />
            </xsl:call-template>
            <xsl:call-template name="insuranceReplacementChecklistInsurancePremiumTypeCell">
                <xsl:with-param name="theNode" select="proposedInsuranceSumDetails" />
            </xsl:call-template>
        </tr>
        <tr>
            <td class="bookletKeyColumn">Indexation linked?</td>
            <td>
                <xsl:call-template name="yesNoTemplate">
                    <xsl:with-param name="boolValue" select="currentInsuranceSumDetails/indexationLinkedFlag" />
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="yesNoTemplate">
                    <xsl:with-param name="boolValue" select="proposedInsuranceSumDetails/indexationLinkedFlag" />
                </xsl:call-template>
            </td>
        </tr>
        <tr>
            <td class="bookletKeyColumn">Premium payable (p.a.)</td>
            <td>
                <!--Frequency : <xsl:value-of select="currentInsuranceSumDetails/premiumPayableFrequency" /> <br />
				
				<xsl:if test="currentInsuranceSumDetails/premiumPayableType = 'TotalPremium'">
					Total Premium : $<xsl:call-template name="formatUnit" >
						<xsl:with-param name="unitValue" select="currentInsuranceSumDetails/premiumPayble" />
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="currentInsuranceSumDetails/premiumPayableType = 'PremiumBreakdown'">as
				</xsl:if>
				-->
                <xsl:call-template name="insurancePremiumBreakdown">
                    <xsl:with-param name="theNode" select="currentInsuranceSumDetails" />
                </xsl:call-template>
            </td>
            <td>
                <!--
				Frequency : <xsl:value-of select="proposedInsuranceSumDetails/premiumPayableFrequency" /> 
				<br />
				$
				<xsl:if test="proposedInsuranceSumDetails/premiumPayableType = 'TotalPremium'">
				<xsl:call-template name="formatUnit" >
					<xsl:with-param name="unitValue" select="proposedInsuranceSumDetails/premiumPayble" />
				</xsl:call-template>
				</xsl:if>
				-->
                <xsl:call-template name="insurancePremiumBreakdown">
                    <xsl:with-param name="theNode" select="proposedInsuranceSumDetails" />
                </xsl:call-template>

            </td>
        </tr>


        <xsl:if test="string-length(currentInsuranceSumDetails/policyFee) > 0">
            <tr>
                <td class="bookletKeyColumn">Policy Fee</td>
                <td>$
                    <xsl:call-template name="formatUnit" >
                        <xsl:with-param name="unitValue" select="currentInsuranceSumDetails/policyFee" />
                    </xsl:call-template>
                </td>
                <td>$
                    <xsl:call-template name="formatUnit" >
                        <xsl:with-param name="unitValue" select="proposedInsuranceSumDetails/policyFee" />
                    </xsl:call-template>
                </td>
            </tr>
        </xsl:if>
        <!--
		<tr>
			<td class="bookletKeyColumn">Occupation Category (from quote)</td>
			<td><xsl:value-of select="currentInsuranceSumDetails/occupationCategoryValue" /></td>
			<td><xsl:value-of select="proposedInsuranceSumDetails/occupationCategoryValue" /></td>
		</tr>
		<tr>
			<td class="bookletKeyColumn">Smoker Flag</td>
			<td>
				<xsl:call-template name="yesNoTemplate" >
					<xsl:with-param name="boolValue" select="currentInsuranceSumDetails/smokerFlag" />
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="yesNoTemplate" >
					<xsl:with-param name="boolValue" select="proposedInsuranceSumDetails/smokerFlag" />
				</xsl:call-template>
			</td>
		</tr>
		-->
    </xsl:template>

    <!-- RC insuranceReplacementChecklistInsuranceResultDetails -->
    <xsl:template name="insuranceReplacementChecklistInsuranceResultDetails">
        <tr>
            <td class="bookletStrongKeyColumn" colspan="3">Will the replacement result in:</td>
        </tr>
        <tr>
            <td class="bookletKeyColumn">Increased Premium/Policy fee (p.a)</td>
            <xsl:call-template name="printInvestmentReplacement" >
                <xsl:with-param name="flagNode" select="insuranceResultDetails/increaseFeeFlag" />
                <xsl:with-param name="valueNode" select="insuranceResultDetails/increasedFeeDetails" />
            </xsl:call-template>
        </tr>
        <tr>
            <td class="bookletKeyColumn">Health loadings</td>
            <xsl:call-template name="printInvestmentReplacement" >
                <xsl:with-param name="flagNode" select="insuranceResultDetails/healthLoadingsFlag" />
                <xsl:with-param name="valueNode" select="insuranceResultDetails/healthLoadingsDetails" />
            </xsl:call-template>
        </tr>
        <tr>
            <td class="bookletKeyColumn">Loss of loyalty discount</td>
            <xsl:call-template name="printInvestmentReplacement" >
                <xsl:with-param name="flagNode" select="insuranceResultDetails/loyatyDiscountFlag" />
                <xsl:with-param name="valueNode" select="insuranceResultDetails/loyatyDiscountDetails" />
            </xsl:call-template>
        </tr>
        <tr>
            <td class="bookletKeyColumn">Loss of benefit (e.g. suicide exclusion)</td>
            <xsl:call-template name="printInvestmentReplacement" >
                <xsl:with-param name="flagNode" select="insuranceResultDetails/benefitLossFlag" />
                <xsl:with-param name="valueNode" select="insuranceResultDetails/benefitLossDetails" />
            </xsl:call-template>
        </tr>
        <tr>
            <td class="bookletKeyColumn">Loss of bonus (e.g. Whole of life/edowment policies)</td>
            <xsl:call-template name="printInvestmentReplacement" >
                <xsl:with-param name="flagNode" select="insuranceResultDetails/bonusLossFlag" />
                <xsl:with-param name="valueNode" select="insuranceResultDetails/bonusLossDetails" />
            </xsl:call-template>
        </tr>
        <tr>
            <td class="bookletKeyColumn">Surrender Value</td>
            <xsl:call-template name="printInvestmentReplacement" >
                <xsl:with-param name="flagNode" select="insuranceResultDetails/surrenderFlag" />
                <xsl:with-param name="valueNode" select="insuranceResultDetails/surrenderValue" />
            </xsl:call-template>
        </tr>
        <tr>
            <td class="bookletKeyColumn">Is there an option to increase/decrease the existing policy? <br />(note:some older policies have more favourable termsthan newer policies)</td>
            <xsl:call-template name="printInvestmentReplacement" >
                <xsl:with-param name="flagNode" select="insuranceResultDetails/increasePolicyFlag" />
                <xsl:with-param name="valueNode" select="insuranceResultDetails/increasePolicyDetails" />
            </xsl:call-template>
        </tr>
    </xsl:template>

    <xsl:template name="insurancePremiumBreakdown">
        <xsl:param name="theNode" />
        <!--
		<b>Frequency : </b> <xsl:value-of select="$theNode/premiumPayableFrequency" /> <br />
		-->
        <xsl:if test="$theNode/premiumPayableType = 'TotalPremium'">
            <b>Total Premium : </b>
            $
            <xsl:call-template name="formatUnit" >
                <xsl:with-param name="unitValue" select="$theNode/premiumPayble" />
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$theNode/premiumPayableType = 'PremiumBreakdown'">

            <table class="bookletTable">
                <tr class="bookletRowHeader">
                    <td width="50%">Premium Type</td>
                    <td width="50%">Value</td>
                </tr>

                <xsl:for-each select="$theNode/premiumBreakdownFees/item">
                    <tr>
                        <td><xsl:value-of select="feeType" /></td>
                        <td>$
                            <xsl:call-template name="formatUnit" >
                                <xsl:with-param name="unitValue" select="feeValue" />
                            </xsl:call-template>
                        </td>
                    </tr>
                </xsl:for-each>
            </table>
        </xsl:if>

    </xsl:template>
    <!-- Prints out the Stepped or Level premium type based on the flag -->
    <xsl:template name="insuranceReplacementChecklistInsurancePremiumTypeCell">
        <xsl:param name="theNode" />
        <td>
            <xsl:value-of select="$theNode/premiumStructureType" />
            <!--
			<xsl:choose>
				<xsl:when test="$theNode/premiumStructureType/text() = 'true'">Stepped</xsl:when>
				<xsl:otherwise>Level</xsl:otherwise>
			</xsl:choose>
			-->
        </td>
    </xsl:template>

    <!--
		Prints the detailed cell for a product insurance sum.
	-->
    <xsl:template name="insuranceReplacementChecklistInsuranceIncomeProtectionCell">
        <xsl:param name="theNode" />
        <td>
            <xsl:choose>
                <xsl:when test="string-length($theNode/incomeProtectionValue) > 0">
                    <xsl:call-template name="printAgreedValue">
                        <xsl:with-param name="theNode" select="$theNode" />
                    </xsl:call-template>
                    <br/>


                    <!--
					<xsl:if test="$theNode/incomeProtectionTPDTypeFlag/text() = 'true'">
						TPD Option - Yes
					</xsl:if>
					<br/><b>Waiting period : </b><xsl:value-of select="$theNode/incomeWaitingPeriodValue" />
					<br/><b>Benefit period : </b><xsl:value-of select="$theNode/incomeBenefitPeriodValue" />
					-->
                    <b>Salary Insured : </b>
                    $<xsl:value-of select="$theNode/salaryInsuredValue" />

                    <br/><b>Waiting period : </b>
                    <xsl:call-template name="genericFormatOther" >
                        <xsl:with-param name="other" select="$theNode/incomeWaitingPeriodValue" />
                        <xsl:with-param name="otherDetails" select="$theNode/incomeWaitingPeriodOther" />
                    </xsl:call-template>
                    <br/><b>Benefit period: </b>
                    <xsl:call-template name="genericFormatOther" >
                        <xsl:with-param name="other" select="$theNode/incomeBenefitPeriodValue" />
                        <xsl:with-param name="otherDetails" select="$theNode/incomeBenefitPeriodOther" />
                    </xsl:call-template>
                    <br /><b>Occupation Category: </b><xsl:value-of select="$theNode/occupationCategoryValue" />
                    <br /><b>Smoker:</b>
                    <xsl:call-template name="yesNoTemplate" >
                        <xsl:with-param name="boolValue" select="$theNode/smokerFlag" />
                    </xsl:call-template>
                    <br /><b>TPD Option : </b>
                    <xsl:call-template name="yesNoTemplate" >
                        <xsl:with-param name="boolValue" select="$theNode/incomeProtectionTPDTypeFlag" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>No Income Protection</xsl:otherwise>
            </xsl:choose>
        </td>
    </xsl:template>

    <!-- Print the agreed value text. -->
    <xsl:template name="printAgreedValue" >
        <xsl:param name="theNode" />
        <xsl:choose>
            <xsl:when test="$theNode/incomeAgreedValueFlag/text() = 'true'">
                <b>Agreed value : </b>
                <xsl:if test="$theNode/incomeProtectionValueDollarFlag/text() = 'true'">$</xsl:if>
                <xsl:value-of select="$theNode/incomeProtectionValue" />
                <xsl:if test="$theNode/incomeProtectionValueDollarFlag/text() = 'false'">%</xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <b>Indemnity value : </b>
                <xsl:if test="$theNode/incomeProtectionValueDollarFlag/text() = 'true'">$</xsl:if>
                <xsl:value-of select="$theNode/incomeProtectionValue" />
                <xsl:if test="$theNode/incomeProtectionValueDollarFlag/text() = 'false'">%</xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
		Prints the Superannuation/Pension replacement checklist
	-->
    <xsl:template match="/variable/clientAuthorisation/item[productCategory/text() = 'Superannuation/Pension']">
        <!--<div class="page-break"></div>-->
        <div class="page-break"> - </div>
        <h2>Superannuation/Pension Replacement Checklist (<xsl:value-of select="description/text()"/>)</h2>
        <xsl:call-template name="printLinkedChecklists">
            <xsl:with-param name="description" select="description" />
        </xsl:call-template>
        <xsl:call-template name="printSuperAnnuationReplacementCheckListSuperDetails" />
        <xsl:call-template name="printSuperAnnuationReplacementCheckListSuperSummaryFooterTable" />
        <xsl:call-template name="genericUnderlyingInvestmentDetails" />
        <xsl:call-template name="genericReplacementChecklistFeesRows">
            <xsl:with-param name="tableHeadingName">Platform Fees</xsl:with-param>
            <xsl:with-param name="tableDefinitionName">SuperReplacementChecklistFeesTable</xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="printSuperAnnuationReplacementCheckListSuperAssetAllocation" />
        <xsl:call-template name="genericReplacementCheckListProductFeatures" />
        <xsl:call-template name="printSuperAnnuationReplacementCheckListSuperQuestionaireAndDetails" />
        <xsl:apply-templates select="checklistQuickPlanSuper" />
        <xsl:call-template name="printBenefitsJustifications">
            <xsl:with-param name="theText" select="justification/Details" />
            <xsl:with-param name="type">Superannuation/Pension</xsl:with-param>
            <xsl:with-param name="unableToAccessInfoFlag" select="justification/unableToAccessInfoFlag" />
            <xsl:with-param name="Notes" select="justification/Notes" />
        </xsl:call-template>
        <xsl:call-template name="printNotes">
            <xsl:with-param name="theText" select="justification/Notes" />
        </xsl:call-template>
    </xsl:template>

    <!--
		Prints the details for the superannuation replacement checklist (table 1)
	-->
    <xsl:template name="printSuperAnnuationReplacementCheckListSuperDetails">
        <table class="bookletTable">
            <tr class="bookletRowHeader">
                <td width="16%">Superannuation Details</td>
                <td width="42%">Current</td>
                <td width="42%">Proposed</td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Superannuation Provider</td>
                <td><xsl:value-of select="currentSuperDetails/superProvider" /></td>
                <td><xsl:value-of select="proposedSuperDetails/superProvider" /></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Product Name</td>
                <td><xsl:value-of select="currentSuperDetails/productName" /></td>
                <td><xsl:value-of select="proposedSuperDetails/productName" /></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">ABN</td>
                <td><xsl:value-of select="currentSuperDetails/abn" /></td>
                <td><xsl:value-of select="proposedSuperDetails/abn" /></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">SPIN/USI</td>
                <td><xsl:value-of select="currentSuperDetails/usi" /></td>
                <td><xsl:value-of select="proposedSuperDetails/usi" /></td>
            </tr>

            <tr>
                <td class="bookletKeyColumn">Type of fund</td>
                <td>
                    <xsl:call-template name="genericFormatOther" >
                        <xsl:with-param name="other" select="currentSuperDetails/fundType" />
                        <xsl:with-param name="otherDetails" select="currentSuperDetails/fundTypeOther" />
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name="genericFormatOther" >
                        <xsl:with-param name="other" select="proposedSuperDetails/fundType" />
                        <xsl:with-param name="otherDetails" select="proposedSuperDetails/fundTypeOther" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Fund Structure</td>
                <td>
                    <xsl:call-template name="printSuperItemList">
                        <xsl:with-param name="theNode" select="currentSuperDetails/fundSubTypes" />
                    </xsl:call-template>
                    <xsl:if test="currentSuperDetails/fundSubTypeOther">
                        <br></br>Other - <xsl:value-of select="currentSuperDetails/fundSubTypeOther" />
                    </xsl:if>
                </td>
                <td>
                    <xsl:call-template name="printSuperItemList">
                        <xsl:with-param name="theNode" select="proposedSuperDetails/fundSubTypes" />
                    </xsl:call-template>
                    <xsl:if test="proposedSuperDetails/fundSubTypeOther">
                        <br></br>Other - <xsl:value-of select="proposedSuperDetails/fundSubTypeOther" />
                    </xsl:if>
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Product Owner(s)</td>
                <td>
                    <xsl:call-template name="printClientListItemForRC">
                        <xsl:with-param name="clientListItem" select="currentSuperDetails/productOwners" />
                        <xsl:with-param name="otherFlag" select="currentSuperDetails/otherProductOwnersFlag" />
                        <xsl:with-param name="otherDesc" select="currentSuperDetails/otherProductOwners" />
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name="printClientListItemForRC">
                        <xsl:with-param name="clientListItem" select="proposedSuperDetails/productOwners" />
                        <xsl:with-param name="otherFlag" select="proposedSuperDetails/otherProductOwnersFlag" />
                        <xsl:with-param name="otherDesc" select="proposedSuperDetails/otherProductOwners" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Fund Membership number</td>
                <td><xsl:value-of select="currentSuperDetails/fundMembershipNumber" /></td>
                <td><xsl:value-of select="proposedSuperDetails/fundMembershipNumber" /></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Date joined: </td>
                <td>
                    <xsl:call-template name="formatTWDate" >
                        <xsl:with-param name="dateValue" select="currentSuperDetails/joinedDate" />
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name="formatTWDate" >
                        <xsl:with-param name="dateValue" select="proposedSuperDetails/joinedDate" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Eligible Start Date</td>
                <td><!--<xsl:value-of select="currentSuperDetails/eligibleStartDate" />-->
                    <xsl:call-template name="formatTWDate" >
                        <xsl:with-param name="dateValue" select="currentSuperDetails/eligibleStartDate" />
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name="formatTWDate" >
                        <xsl:with-param name="dateValue" select="proposedSuperDetails/eligibleStartDate" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Balance</td>
                <!--
				<td>OOOOOO :<xsl:value-of select="currentSuperDetails/currentBalance" /></td>
				<td>OOOOOO :<xsl:value-of select="proposedSuperDetails/currentBalance" /></td>
				-->

                <td>$
                    <xsl:call-template name="formatUnit" >
                        <xsl:with-param name="unitValue" select="currentSuperDetails/currentBalance" />
                    </xsl:call-template>
                </td>
                <td>$
                    <xsl:call-template name="formatUnit" >
                        <xsl:with-param name="unitValue" select="proposedSuperDetails/currentBalance" />
                    </xsl:call-template>
                </td>

            </tr>
            <!-- RC_10 -->
            <tr>
                <td class="bookletKeyColumn">Surrender value</td>
                <td>$
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="currentSuperDetails/surrenderValue" />
                    </xsl:call-template>
                </td>
                <td>$
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="proposedSuperDetails/surrenderValue" />
                    </xsl:call-template>
                </td>
            </tr>
            <!-- removed as per RC_10
			<tr>
				<td class="bookletKeyColumn">Regular contribution received?</td>
				<td>
					<xsl:call-template name="printYesNoAndAmount">
						<xsl:with-param name="theFlag" select="currentSuperDetails/regularContributionReceivedFlag" />
						<xsl:with-param name="theAmount" select="currentSuperDetails/regularContributionReceivedAmt" />
					</xsl:call-template>
				</td>
				<td class="bookletKeyColumn">
					<xsl:call-template name="printYesNoAndAmount">
						<xsl:with-param name="theFlag" select="proposedSuperDetails/regularContributionReceivedFlag" />
						<xsl:with-param name="theAmount" select="proposedSuperDetails/regularContributionReceivedAmt" />
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<td class="bookletKeyColumn">Type of contribution</td>
				<td>
					<xsl:call-template name="printSuperContributors">
						
						<xsl:with-param name="contributionType" select="currentSuperDetails/contributionType" />
					</xsl:call-template>
				</td>
				<td>
					<xsl:call-template name="printSuperContributors">
						
						<xsl:with-param name="contributionType" select="proposedSuperDetails/contributionType" />
					</xsl:call-template>
				</td>
			</tr>
			-->
            <tr>
                <td class="bookletKeyColumn">Regular Contributions Received</td>
                <td>

                    <xsl:call-template name="contributionsReceived">
                        <xsl:with-param name="productSuperDetails" select="currentSuperDetails" />
                    </xsl:call-template>
                    <!--
					<xsl:call-template name="printYesNoAndAmount">
						<xsl:with-param name="theFlag" select="currentSuperDetails/contReceivedOverFlag" />
						<xsl:with-param name="theAmount" select="currentSuperDetails/contReceivedOverAmt" />
					</xsl:call-template>
					-->
                </td>
                <td>
                    <xsl:call-template name="contributionsReceived">
                        <xsl:with-param name="productSuperDetails" select="proposedSuperDetails" />
                    </xsl:call-template>
                    <!--
					<xsl:call-template name="printYesNoAndAmount">
						<xsl:with-param name="theFlag" select="proposedSuperDetails/contReceivedOverFlag" />
						<xsl:with-param name="theAmount" select="proposedSuperDetails/contReceivedOverAmt" />
					</xsl:call-template>
					-->
                </td>
            </tr>

            <tr>
                <td class="bookletKeyColumn">Tax Free Component</td>
                <td>
                    <xsl:call-template name="dollarPercentTemplate">
                        <xsl:with-param name="unitValue" select="currentSuperDetails/taxFreeAmt" /><xsl:with-param name="unit" select="currentSuperDetails/taxFreeType" />
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name="dollarPercentTemplate">
                        <xsl:with-param name="unitValue" select="proposedSuperDetails/taxFreeAmt" /><xsl:with-param name="unit" select="proposedSuperDetails/taxFreeType" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Taxed Component</td>
                <td>
                    Taxed :
                    <xsl:call-template name="dollarPercentTemplate">
                        <xsl:with-param name="unitValue" select="currentSuperDetails/taxableAmt" /><xsl:with-param name="unit" select="currentSuperDetails/taxableType" />
                    </xsl:call-template>
                    <br />Untaxed :
                    <xsl:call-template name="dollarPercentTemplate">
                        <xsl:with-param name="unitValue" select="currentSuperDetails/untaxedAmt" /><xsl:with-param name="unit" select="currentSuperDetails/untaxedType" />
                    </xsl:call-template>
                </td>
                <td>
                    Taxed :
                    <xsl:call-template name="dollarPercentTemplate">
                        <xsl:with-param name="unitValue" select="proposedSuperDetails/taxableAmt" /><xsl:with-param name="unit" select="proposedSuperDetails/taxableType" />
                    </xsl:call-template>
                    <br />Untaxed :
                    <xsl:call-template name="dollarPercentTemplate">
                        <xsl:with-param name="unitValue" select="proposedSuperDetails/untaxedAmt" /><xsl:with-param name="unit" select="proposedSuperDetails/untaxedType" />
                    </xsl:call-template>
                </td>
            </tr>
            <!--
			<tr>
				<td class="bookletKeyColumn">Untaxed Component</td>
				<td>
					<xsl:call-template name="dollarPercentTemplate">
						<xsl:with-param name="unitValue" select="currentSuperDetails/untaxedAmt" /><xsl:with-param name="unit" select="currentSuperDetails/untaxedType" />
					</xsl:call-template>
				</td>
				<td>
					<xsl:call-template name="dollarPercentTemplate">
						<xsl:with-param name="unitValue" select="proposedSuperDetails/untaxedAmt" /><xsl:with-param name="unit" select="proposedSuperDetails/untaxedType" />
					</xsl:call-template>
				</td>
			</tr>
			-->

            <tr>
                <td class="bookletKeyColumn">Preservation Status</td>
                <td>
                    Preservation :
                    <xsl:call-template name="dollarPercentTemplate">
                        <xsl:with-param name="unitValue" select="currentSuperDetails/compulsoryPreservedBenefit" /><xsl:with-param name="unit" select="'Dollar'" />
                    </xsl:call-template>
                    <br />Restricted Non-Preserved :
                    <xsl:call-template name="dollarPercentTemplate">
                        <xsl:with-param name="unitValue" select="currentSuperDetails/restrictedNonreservedAmt" /><xsl:with-param name="unit" select="'Dollar'" />
                    </xsl:call-template>
                    <br />Unrestricted Non-Preserved :
                    <xsl:call-template name="dollarPercentTemplate">
                        <xsl:with-param name="unitValue" select="currentSuperDetails/unrestrictedNonPreservedAmt" /><xsl:with-param name="unit" select="'Dollar'" />
                    </xsl:call-template>
                </td>
                <td>
                    Preservation  :
                    <xsl:call-template name="dollarPercentTemplate">
                        <xsl:with-param name="unitValue" select="proposedSuperDetails/compulsoryPreservedBenefit" /><xsl:with-param name="unit" select="'Dollar'" />
                    </xsl:call-template>
                    <br />Restricted Non-Preserved :
                    <xsl:call-template name="dollarPercentTemplate">
                        <xsl:with-param name="unitValue" select="proposedSuperDetails/restrictedNonreservedAmt" /><xsl:with-param name="unit" select="'Dollar'" />
                    </xsl:call-template>
                    <br />Unrestricted Non-Preserved :
                    <xsl:call-template name="dollarPercentTemplate">
                        <xsl:with-param name="unitValue" select="proposedSuperDetails/unrestrictedNonPreservedAmt" /><xsl:with-param name="unit" select="'Dollar'" />
                    </xsl:call-template>
                </td>
            </tr>
            <!--
			<tr>
				<td class="bookletKeyColumn">Restricted Non-Preserved</td>
				<td>
					<xsl:call-template name="dollarPercentTemplate">
						<xsl:with-param name="unitValue" select="currentSuperDetails/restrictedNonreservedAmt" /><xsl:with-param name="unit" select="'Dollar'" />
					</xsl:call-template>
				</td>
				<td>
					<xsl:call-template name="dollarPercentTemplate">
						<xsl:with-param name="unitValue" select="proposedSuperDetails/restrictedNonreservedAmt" /><xsl:with-param name="unit" select="'Dollar'" />
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<td class="bookletKeyColumn">Unrestricted Non-Preserved</td>
				<td>
					<xsl:call-template name="dollarPercentTemplate">
						<xsl:with-param name="unitValue" select="currentSuperDetails/unrestrictedNonPreservedAmt" /><xsl:with-param name="unit" select="'Dollar'" />
					</xsl:call-template>
				</td>
				<td>
					<xsl:call-template name="dollarPercentTemplate">
						<xsl:with-param name="unitValue" select="proposedSuperDetails/unrestrictedNonPreservedAmt" /><xsl:with-param name="unit" select="'Dollar'" />
					</xsl:call-template>
				</td>
			</tr>
			-->
            <!--
			<tr>
				<td class="bookletKeyColumn">Preservation Status:</td>
				<td>
					<xsl:call-template name="printSuperItemList">
						<xsl:with-param name="theNode" select="currentSuperDetails/contributionSubType" />
					</xsl:call-template>
				</td>
				<td>
					<xsl:call-template name="printSuperItemList">
						<xsl:with-param name="theNode" select="proposedSuperDetails/contributionSubType" />
					</xsl:call-template>
				</td>
			</tr>
-->
            <tr>
                <td class="bookletKeyColumn">Type of Nomination</td>
                <td>
                    <xsl:value-of select="currentSuperDetails/singleNominationType" />
                </td>
                <td>
                    <xsl:value-of select="proposedSuperDetails/singleNominationType" />
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Beneficiaries</td>
                <td>
                    <xsl:call-template name="printSuperBeneficiaries">
                        <xsl:with-param name="theNode" select="currentSuperDetails" />
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name="printSuperBeneficiaries">
                        <xsl:with-param name="theNode" select="proposedSuperDetails" />
                    </xsl:call-template>
                </td>
            </tr>

        </table>
    </xsl:template>

    <xsl:template name="contributionsReceived">
        <xsl:param name="productSuperDetails" />

        <table class="bookletTable">
            <tr class="bookletRowTallyHeader">
                <td colspan="3">Current Financial Year</td>
            </tr>
            <tr>
                <td class="bookletStrongKeyColumn" width="40%">Concessional</td>
                <td class="bookletKeyColumn">$
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$productSuperDetails/concessionalCurrentYearContributions/amount" />
                    </xsl:call-template>
                </td>
                <td class="bookletStrongKeyColumn"><xsl:value-of select="$productSuperDetails/concessionalCurrentYearContributions/frequency" /></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Regular YTD</td>
                <td colspan="2">$
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$productSuperDetails/concessionalCurrentYearContributions/regularYTD" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Lump Sum YTD</td>
                <td colspan="2">$
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$productSuperDetails/concessionalCurrentYearContributions/lumpSumYTD" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletStrongKeyColumn" width="40%">Non-Concessional</td>
                <td class="bookletKeyColumn">$
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$productSuperDetails/nonConcessionalCurrentYearContributions/amount" />
                    </xsl:call-template>
                </td>
                <td class="bookletStrongKeyColumn"><xsl:value-of select="$productSuperDetails/nonConcessionalCurrentYearContributions/frequency" /></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Regular YTD</td>
                <td colspan="2">$
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$productSuperDetails/nonConcessionalCurrentYearContributions/regularYTD" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Lump Sum YTD</td>
                <td colspan="2">$
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$productSuperDetails/nonConcessionalCurrentYearContributions/lumpSumYTD" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletStrongKeyColumn" width="40%">Other - <xsl:value-of select="$productSuperDetails/otherCurrentYearContributions/otherType" /></td>
                <td class="bookletKeyColumn">$
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$productSuperDetails/otherCurrentYearContributions/amount" />
                    </xsl:call-template>
                </td>
                <td class="bookletStrongKeyColumn"><xsl:value-of select="$productSuperDetails/otherCurrentYearContributions/frequency" /></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Regular YTD</td>
                <td colspan="2">$
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$productSuperDetails/otherCurrentYearContributions/regularYTD" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Lump Sum YTD</td>
                <td colspan="2">$
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$productSuperDetails/otherCurrentYearContributions/lumpSumYTD" />
                    </xsl:call-template>
                </td>
            </tr>




            <tr class="bookletRowTallyHeader">
                <td colspan="3">Previous Financial Year 1 (Regular and/or Lump Sum)</td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Concessional</td>
                <td colspan="2">$
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$productSuperDetails/previousFinancialYear1Contributions/concessionalAmount" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Non-Concessional</td>
                <td colspan="2">$
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$productSuperDetails/previousFinancialYear1Contributions/nonConcessionalAmount" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Other - <xsl:value-of select="$productSuperDetails/previousFinancialYear1Contributions/otherType" /></td>
                <td colspan="2">$
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$productSuperDetails/previousFinancialYear1Contributions/otherAmount" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr class="bookletRowTallyHeader">
                <td colspan="3">Previous Financial Year 2 (Regular and/or Lump Sum)</td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Concessional</td>
                <td colspan="2">$
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$productSuperDetails/previousFinancialYear2Contributions/concessionalAmount" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Non-Concessional</td>
                <td colspan="2">$
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$productSuperDetails/previousFinancialYear2Contributions/nonConcessionalAmount" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Other - <xsl:value-of select="$productSuperDetails/previousFinancialYear2Contributions/otherType" /></td>
                <td colspan="2">$
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$productSuperDetails/previousFinancialYear2Contributions/otherAmount" />
                    </xsl:call-template>
                </td>
            </tr>


        </table>
    </xsl:template>
    <!-- Anonymous table with the superannuation summary of product details -->
    <xsl:template name="printSuperAnnuationReplacementCheckListSuperSummaryFooterTable" >
        <xsl:variable name="insuranceAttachedFlag" select="superInsurance/insuranceAttachedFlag" />
        <br/>
        <table class="bookletTable">
            <tr>
                <td class="bookletKeyColumn">Current Death/TPD/Salary Continuance benefit</td>
                <xsl:choose>
                    <!-- NOTE: This has been added here as part of defect #1558. This is what John requested because
							   there is a bug in this section where these values are not populated in the source data 
							   (i.e. adviceRequest). Please REMOVE when this has been fixed.
					-->
                    <xsl:when test="$insuranceAttachedFlag = 'true'">
                        <td>see insurance replacement checklist</td>
                    </xsl:when>
                    <xsl:otherwise>
                        <td>$<xsl:value-of select="max((superInsurance/deathInsuranceBenefitValue/text(),
									superInsurance/tpdInsuranceBenefitValue/text(),
									superInsurance/ipInsuranceBenefitValue/text()))" /></td>
                    </xsl:otherwise>
                </xsl:choose>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Premium</td>
                <xsl:choose>
                    <!-- NOTE: This has been added here as part of defect #1558. This is what John requested because
							   there is a bug in this section where these values are not populated in the source data 
							   (i.e. adviceRequest). Please REMOVE when this has been fixed.
					-->
                    <xsl:when test="$insuranceAttachedFlag = 'true'">
                        <td>see insurance replacement checklist</td>
                    </xsl:when>
                    <xsl:otherwise>
                        <td>
                            $<xsl:value-of select="superInsurance/premiumStructureValue" />
                            <br/>
                            <xsl:choose>
                                <xsl:when test="superInsurance/feeSteppedFlag/text() = 'true'">Stepped</xsl:when>
                                <xsl:otherwise>Level</xsl:otherwise>
                            </xsl:choose>
                            <br/>Policy Fee $<xsl:value-of select="superInsurance/policyFeeValue" />
                        </td>
                    </xsl:otherwise>
                </xsl:choose>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Is there an existing insurance policy attached to the current superannuation fund?</td>
                <td>
                    <xsl:call-template name="yesNoTemplate">
                        <xsl:with-param name="boolValue" select="$insuranceAttachedFlag" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn" colspan="2">If yes, please complete the insurance replacement checklist.</td>
            </tr>
        </table>
    </xsl:template>

    <!--	Super platform fees table. -->
    <!--
	<xsl:template name="printSuperAnnuationReplacementCheckListSuperPlatformFees" >
		<br/>
		<table class="bookletTable">
			<tr class="bookletRowHeader">
				<td colspan="5">Platform Fees</td>
			</tr>
			<tr>
				<td class="bookletStrongKeyColumn" rowspan="2">Type of fee:</td>
				<td class="bookletStrongKeyTallyColumn" colspan="2">Current</td>
				<td class="bookletStrongKeyTallyColumn" colspan="2">Proposed</td>
			</tr>
			<tr>
				<td class="bookletStrongKeyTallyColumn">($)</td>
				<td class="bookletStrongKeyTallyColumn">(%)</td>
				<td class="bookletStrongKeyTallyColumn">($)</td>
				<td class="bookletStrongKeyTallyColumn">(%)</td>
			</tr>
			<xsl:variable name="currentFees" select="currentFeeDetails" />
			<xsl:variable name="proposedFees" select="proposedFeeDetails" />
			<xsl:for-each select="$tableDefinitions/tables/table[@name='ReplacementChecklistFeesTable']/tr" >
				<xsl:variable name="feeName" select="@node" />
				<tr>
					<xsl:copy-of select="td" />
					<td class="bookletTallyCell"><xsl:value-of select="$currentFees/item[feeType/text() = $feeName and feeMethod = 'Dollar']/feeValue" /></td>
					<td class="bookletTallyCell"><xsl:value-of select="$currentFees/item[feeType/text() = $feeName and feeMethod = 'Percent']/feeValue" /></td>
					<td class="bookletTallyCell"><xsl:value-of select="$proposedFees/item[feeType/text() = $feeName and feeMethod = 'Dollar']/feeValue" /></td>
					<td class="bookletTallyCell"><xsl:value-of select="$proposedFees/item[feeType/text() = $feeName and feeMethod = 'Percent']/feeValue" /></td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
	-->
    <!-- Super platform asset allocation -->
    <xsl:template name="printSuperAnnuationReplacementCheckListSuperAssetAllocation" >
        <br/>
        <xsl:call-template name="genericReplacementCheckListAssetAllocation" />
    </xsl:template>

    <!-- Prints super contribution types -->
    <xsl:template name="printSuperContributors" >
        <xsl:param name="contributionType" />
        <xsl:variable name="itemAbove" />
        <xsl:if test="$contributionType/isSelected = 'true'">
            <xsl:if test="$contributionType/concessional = 'true'">
                <xsl:text>Concessional</xsl:text>
            </xsl:if>
            <xsl:if test="$contributionType/nonConcessional = 'true'">
                <br/><xsl:text>Non Concessional</xsl:text>
            </xsl:if>
            <xsl:if test="$contributionType/other = 'true'">
                <br/>
                <xsl:call-template name="genericFormatOther" >
                    <xsl:with-param name="other" >Other</xsl:with-param>
                    <xsl:with-param name="otherDetails" select="$contributionType/otherDetails" />
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <!-- Prints all the contribution types over line breaks -->
    <!--
	<xsl:template name="printSuperContributors" >
		<xsl:param name="theNode" />
		<xsl:for-each select="$theNode/contributionType/item[isSelected='true']">
			<xsl:if test="position() > 1"><br/></xsl:if>
			<xsl:value-of select="type" />
		</xsl:for-each>
	</xsl:template>
	-->

    <!-- Prints all the contribution sub types -->
    <xsl:template name="printSuperItemList" >
        <xsl:param name="theNode" />
        <xsl:for-each select="$theNode/item[string-length(text()) > 0]">
            <xsl:if test="position() > 1"><br/></xsl:if>
            <xsl:value-of select="." />
        </xsl:for-each>
    </xsl:template>

    <!-- Prints all the super beneficiaries sub types -->
    <xsl:template name="printSuperBeneficiaries" >
        <xsl:param name="theNode" />
        <xsl:for-each select="$theNode/beneficiary/item">
            <xsl:if test="position() > 1"><br/></xsl:if>
            <xsl:value-of select="name" /><xsl:text> </xsl:text><xsl:value-of select="percent" />%
        </xsl:for-each>
    </xsl:template>

    <!-- prints yes/no based on the flag and then prints the amount immediately after. -->
    <xsl:template name="printYesNoAndAmount" >
        <xsl:param name="theFlag" />
        <xsl:param name="theAmount" />
        <xsl:choose>
            <xsl:when test="$theFlag = 'true'">
                Yes $<xsl:value-of select="$theAmount" />
            </xsl:when>
            <xsl:otherwise>No</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- The questionnaire about whether the replacement will result in.... -->
    <xsl:template name="printSuperAnnuationReplacementCheckListSuperQuestionaireAndDetails">
        <br/>
        <table class="bookletTable">
            <tr>
                <td  class="bookletStrongKeyColumn" colspan="2">Will the replacement result in:</td>
            </tr>
            <xsl:call-template name="flagAndDetailAcrossRows" >
                <xsl:with-param name="flagDetailName" select="('Capital loss on initial investment')" />
                <xsl:with-param name="flagValue" select="superResultDetails/capitalLoss" />
                <xsl:with-param name="details" select="superResultDetails/capitalLossDetails" />
            </xsl:call-template>
            <xsl:call-template name="flagAndDetailAcrossRows" >
                <xsl:with-param name="flagDetailName" select="('Duplication of entry fees')" />
                <xsl:with-param name="flagValue" select="superResultDetails/feeDuplication" />
                <xsl:with-param name="details" select="superResultDetails/feeDuplicationDetails" />
            </xsl:call-template>
            <xsl:call-template name="flagAndDetailAcrossRows" >
                <xsl:with-param name="flagDetailName" select="('Loss of employer provided insurance e.g. Death/TPD and/or salary continuance', 'Has a replacement been recommended?')" />
                <xsl:with-param name="flagValue" select="superResultDetails/insuranceProvided" />
                <xsl:with-param name="details" select="superResultDetails/insuranceProvidedDetails" />
            </xsl:call-template>
            <xsl:call-template name="flagAndDetailAcrossRows" >
                <xsl:with-param name="flagDetailName" select="('Loss of ancillary benefits?')" />
                <xsl:with-param name="flagValue" select="superResultDetails/ancillaryBenefit" />
                <xsl:with-param name="details" select="superResultDetails/ancillaryBenefitDetails" />
            </xsl:call-template>
            <xsl:call-template name="flagAndDetailAcrossRows" >
                <xsl:with-param name="flagDetailName" select="('If Defined Benefit, has pension option been explored?')" />
                <xsl:with-param name="flagValue" select="superResultDetails/pensionExplored" />
                <xsl:with-param name="details" select="superResultDetails/pensionExploredDetails" />
            </xsl:call-template>
            <xsl:call-template name="flagAndDetailAcrossRows" >
                <xsl:with-param name="flagDetailName" select="('Change in preservation status')" />
                <xsl:with-param name="flagValue" select="superResultDetails/statusChange" />
                <xsl:with-param name="details" select="superResultDetails/statusChangeDetails" />
            </xsl:call-template>
            <xsl:call-template name="flagAndDetailAcrossRows" >
                <xsl:with-param name="flagDetailName" select="('Any impact on Centrelink benefits')" />
                <xsl:with-param name="flagValue" select="superResultDetails/centrelinkImpact" />
                <xsl:with-param name="details" select="superResultDetails/centrelinkImpactDetails" />
            </xsl:call-template>
            <xsl:call-template name="flagAndDetailAcrossRows" >
                <xsl:with-param name="flagDetailName" select="('Change in tax free/taxable component')" />
                <xsl:with-param name="flagValue" select="superResultDetails/taxChange" />
                <xsl:with-param name="details" select="superResultDetails/taxChangeDetails" />
            </xsl:call-template>
            <xsl:call-template name="flagSingleRow" >
                <xsl:with-param name="flagDetailName" select="('Has a Replacement Checklist been Recommended?')" />
                <xsl:with-param name="flagValue" select="superResultDetails/replacementChecklist" />
            </xsl:call-template>

        </table>
    </xsl:template>

    <!--
		Formats the questionnaire row.
	-->
    <xsl:template name="flagAndDetailAcrossRows">
        <xsl:param name="flagDetailName" />
        <xsl:param name="flagValue" />
        <xsl:param name="details" />
        <tr>
            <td class="bookletKeyColumn" rowspan="2">
                <xsl:value-of select="$flagDetailName[position() = 1]" />
                <br/>If yes, please provide details:
                <br/><xsl:value-of select="$flagDetailName[position() = 2]" />
            </td>
            <td>
                <xsl:call-template name="yesNoTemplate">
                    <xsl:with-param name="boolValue" select="$flagValue" />
                </xsl:call-template>
            </td>
        </tr>
        <tr>
            <td><xsl:value-of select="$details" /></td>
        </tr>
    </xsl:template>

    <!-- Formats a single questionnaire row without details -->
    <xsl:template name="flagSingleRow">
        <xsl:param name="flagDetailName" />
        <xsl:param name="flagValue" />
        <tr>
            <td class="bookletKeyColumn" rowspan="2">
                <xsl:value-of select="$flagDetailName[position() = 1]" />
            </td>
            <td>
                <xsl:call-template name="yesNoTemplate">
                    <xsl:with-param name="boolValue" select="$flagValue" />
                </xsl:call-template>
            </td>
        </tr>
    </xsl:template>

    <!--
		BEGIN UTILITY SECTION FOR REPLACEMENT SECTIONS
	-->

    <!--
		Print all the Product features that are supported and their benefits.
	-->
    <xsl:template name="genericReplacementCheckListProductFeatures" >
        <br/>
        <table class="bookletTable">
            <tr class="bookletRowHeader">
                <td colspan="5">Products Features and Benefits</td>
            </tr>
            <tr class="bookletRowHeader">
                <td class="bookletStrongKeyColumn" width="25%" >Does the product have access to:</td>
                <td class="bookletStrongKeyTallyColumn" colspan="2">Current</td>
                <td class="bookletStrongKeyTallyColumn" colspan="2">Proposed</td>
            </tr>
            <tr>
                <td class="bookletStrongKeyColumn"></td>
                <td class="bookletStrongKeyColumn"></td>
                <td class="bookletStrongKeyColumn">Details</td>
                <td class="bookletStrongKeyColumn"></td>
                <td class="bookletStrongKeyColumn">Details</td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Direct shares</td>
                <td>
                    <xsl:call-template name="yesNoTemplate">
                        <xsl:with-param name="boolValue" select="productBenefits/directSharesExistFlag" />
                    </xsl:call-template>
                </td>
                <td><xsl:value-of select="productBenefits/directSharesDetails" /></td>
                <td>
                    <xsl:call-template name="yesNoTemplate">
                        <xsl:with-param name="boolValue" select="proposedProductBenefits/directSharesExistFlag" />
                    </xsl:call-template>
                </td>
                <td><xsl:value-of select="proposedProductBenefits/directSharesDetails" /></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Term Deposits</td>
                <td>
                    <xsl:call-template name="yesNoTemplate">
                        <xsl:with-param name="boolValue" select="productBenefits/termDepositsExistFlag" />
                    </xsl:call-template>
                </td>
                <td><xsl:value-of select="productBenefits/termDepositDetails" /></td>
                <td>
                    <xsl:call-template name="yesNoTemplate">
                        <xsl:with-param name="boolValue" select="proposedProductBenefits/termDepositsExistFlag" />
                    </xsl:call-template>
                </td>
                <td><xsl:value-of select="proposedProductBenefits/termDepositDetails" /></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Income stream(s)</td>
                <td>
                    <xsl:call-template name="yesNoTemplate">
                        <xsl:with-param name="boolValue" select="productBenefits/incomeStreamExistFlag" />
                    </xsl:call-template>
                </td>
                <td><xsl:value-of select="productBenefits/incomeStreamDetails" /></td>

                <td>
                    <xsl:call-template name="yesNoTemplate">
                        <xsl:with-param name="boolValue" select="proposedProductBenefits/incomeStreamExistFlag" />
                    </xsl:call-template>
                </td>
                <td><xsl:value-of select="proposedProductBenefits/incomeStreamDetails" /></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">In-specie transfer</td>
                <td>
                    <xsl:call-template name="yesNoTemplate">
                        <xsl:with-param name="boolValue" select="productBenefits/transferExistFlag" />
                    </xsl:call-template>
                </td>
                <td><xsl:value-of select="productBenefits/transferDetails" /></td>

                <td>
                    <xsl:call-template name="yesNoTemplate">
                        <xsl:with-param name="boolValue" select="proposedProductBenefits/transferExistFlag" />
                    </xsl:call-template>
                </td>
                <td><xsl:value-of select="proposedProductBenefits/transferDetails" /></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Asset Allocation</td>
                <td>
                    <xsl:call-template name="yesNoTemplate">
                        <xsl:with-param name="boolValue" select="productBenefits/assetAllocationExistFlag" />
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name="formatAssetAllocationDetails" >
                        <xsl:with-param name="existsFlag" select="productBenefits/assetAllocationExistFlag" />
                        <xsl:with-param name="assetAllocation" select="productBenefits/assetAllocation" />
                        <xsl:with-param name="assetAllocationOther" select="productBenefits/assetAllocationOther" />
                    </xsl:call-template>
                </td>

                <td>
                    <xsl:call-template name="yesNoTemplate">
                        <xsl:with-param name="boolValue" select="proposedProductBenefits/assetAllocationExistFlag" />
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name="formatAssetAllocationDetails" >
                        <xsl:with-param name="existsFlag" select="proposedProductBenefits/assetAllocationExistFlag" />
                        <xsl:with-param name="assetAllocation" select="proposedProductBenefits/assetAllocation" />
                        <xsl:with-param name="assetAllocationOther" select="proposedProductBenefits/assetAllocationOther" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Number of Investment Option</td>
                <td>
                    <xsl:value-of select="productBenefits/investmentOptions" />
                </td>
                <td><xsl:value-of select="productBenefits/investmentOptionsDetails" /></td>

                <td>
                    <xsl:value-of select="proposedProductBenefits/investmentOptions" />
                </td>
                <td><xsl:value-of select="proposedProductBenefits/investmentOptionsDetails" /></td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template name="feeDetailsList">
        <xsl:param name="feeDetailsArray" />
        <table class="bookletTable">
            <tr>
                <td class="bookletStrongKeyColumn" >Type of Fee: </td>
                <td class="bookletStrongKeyColumn" colspan='2'>Fee Value:</td>
            </tr>

            <xsl:for-each select="$feeDetailsArray/item">
                <tr>
                    <td class="bookletKeyColumn" ><xsl:value-of select="./feeType" /> </td>
                    <!--<td >-->
                    <xsl:call-template name="dollarPercentTemplateForTD">
                        <xsl:with-param name="unit" select="feeMethod/text()" />
                        <xsl:with-param name="unitValue" select="feeValue/text()" />
                    </xsl:call-template>

                    <!--</td>-->
                </tr>
                <!-- assetValue -->
            </xsl:for-each>
        </table>
    </xsl:template>


    <xsl:template name="genericReplacementChecklistFeesRows" >
        <xsl:param name="tableHeadingName" />
        <xsl:param name="tableDefinitionName" />

        <xsl:variable name="currentFees" select="currentFeeDetails" />
        <xsl:variable name="proposedFees" select="proposedFeeDetails" />
        <br/>
        <table class="bookletTable">
            <tr class="bookletRowHeader">
                <td colspan="2">Platform Fees (Per Annum)</td>
            </tr>
            <tr>
                <td class="bookletStrongKeyColumn" width="50%">Current </td>
                <td class="bookletStrongKeyColumn" width="50%">Proposed</td>
            </tr>
            <tr>
                <td>
                    <xsl:call-template name='feeDetailsList'>
                        <xsl:with-param name="feeDetailsArray" select="$currentFees" />
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name='feeDetailsList'>
                        <xsl:with-param name="feeDetailsArray" select="$proposedFees" />
                    </xsl:call-template>
                </td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template name="genericReplacementChecklistFeesRows_old" >
        <xsl:param name="tableHeadingName" />
        <xsl:param name="tableDefinitionName" />
        <br/>
        <table class="bookletTable">
            <tr class="bookletRowHeader">
                <td colspan="5"><xsl:value-of select="$tableHeadingName" /></td>
            </tr>
            <tr>
                <td class="bookletStrongKeyColumn" rowspan="2">Type of fee:</td>
                <td class="bookletStrongKeyTallyColumn" colspan="2">Current</td>
                <td class="bookletStrongKeyTallyColumn" colspan="2">Proposed</td>
            </tr>
            <tr>
                <td class="bookletStrongKeyTallyColumn">($)</td>
                <td class="bookletStrongKeyTallyColumn">(%)</td>
                <td class="bookletStrongKeyTallyColumn">($)</td>
                <td class="bookletStrongKeyTallyColumn">(%)</td>
            </tr>
            <xsl:variable name="currentFees" select="currentFeeDetails" />
            <xsl:variable name="proposedFees" select="proposedFeeDetails" />
            <xsl:for-each select="$tableDefinitions/tables/table[@name=$tableDefinitionName]/tr" >
                <xsl:variable name="feeName" select="@node" />
                <tr>
                    <xsl:copy-of select="td" />
                    <td class="bookletTallyCell"><xsl:value-of select="$currentFees/item[feeType/text() = $feeName and (feeMethod = '$' or feeMethod = 'Dollar')]/feeValue" /></td>
                    <td class="bookletTallyCell"><xsl:value-of select="$currentFees/item[feeType/text() = $feeName and (feeMethod = '%' or feeMethod = 'Percent')]/feeValue" /></td>
                    <td class="bookletTallyCell"><xsl:value-of select="$proposedFees/item[feeType/text() = $feeName and (feeMethod = '$' or feeMethod = 'Dollar')]/feeValue" /></td>
                    <td class="bookletTallyCell"><xsl:value-of select="$proposedFees/item[feeType/text() = $feeName and (feeMethod = '%' or feeMethod = 'Percent')]/feeValue" /></td>
                </tr>
            </xsl:for-each>

            <!-- Gets remaining distinct names. These are the user added fees. -->
            <xsl:variable name="otherNames" select="distinct-values($currentFees/item[not(feeType/text() = $tableDefinitions/tables/table[@name=$tableDefinitionName]/tr[@node])]/feeType
				| $proposedFees/item[not(feeType/text() = $tableDefinitions/tables/table[@name=$tableDefinitionName]/tr[@node])]/feeType)" />
            <xsl:for-each select="$otherNames">
                <xsl:variable name="otherFeeName" select="." />
                <tr>
                    <td class="bookletKeyColumn">Other - <xsl:value-of select="$otherFeeName" /></td>
                    <td class="bookletTallyCell"><xsl:value-of select="$currentFees/item[feeType/text() = $otherFeeName and (feeMethod = '$' or feeMethod = 'Dollar')]/feeValue" /></td>
                    <td class="bookletTallyCell"><xsl:value-of select="$currentFees/item[feeType/text() = $otherFeeName and (feeMethod = '%' or feeMethod = 'Percent')]/feeValue" /></td>
                    <td class="bookletTallyCell"><xsl:value-of select="$proposedFees/item[feeType/text() = $otherFeeName and (feeMethod = '$' or feeMethod = 'Dollar')]/feeValue" /></td>
                    <td class="bookletTallyCell"><xsl:value-of select="$proposedFees/item[feeType/text() = $otherFeeName and (feeMethod = '%' or feeMethod = 'Percent')]/feeValue" /></td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>

    <!--
		Print all the asset allocations.
	-->
    <xsl:template name="genericReplacementCheckListAssetAllocation" >
        <xsl:variable name="currentAssets"  select="assetAllocationDetails/currentAssetAllocation" />
        <xsl:variable name="proposedAssets" select="assetAllocationDetails/proposedAssetAllocation" />
        <br/>
        <table class="bookletTable">
            <tr class="bookletRowHeader">
                <td colspan="2">Asset Allocation</td>
            </tr>
            <tr>
                <td class="bookletStrongKeyColumn" width="50%">Current </td>
                <td class="bookletStrongKeyColumn" width="50%">Proposed</td>
            </tr>
            <tr>
                <td>
                    <xsl:call-template name='assetAllocationList'>
                        <xsl:with-param name="assetAllocationArray" select="$currentAssets" />
                        <xsl:with-param name="isCurrent">true</xsl:with-param>

                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name='assetAllocationList'>
                        <xsl:with-param name="assetAllocationArray" select="$proposedAssets" />
                        <xsl:with-param name="isCurrent">false</xsl:with-param>
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td colspan="2">Is the proposed (or similar) allocation available on the customer's existing investment? :
                    <xsl:call-template name="yesNoTemplate" >
                        <xsl:with-param name="boolValue" select="assetAllocationDetails/assetAvailableFlag/text()" />
                    </xsl:call-template>
                </td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template name="assetAllocationList">
        <xsl:param name="assetAllocationArray" />
        <xsl:param name="isCurrent" />
        <table class="bookletTable">
            <tr>
                <td class="bookletStrongKeyColumn" >Asset Type </td>
                <td class="bookletStrongKeyColumn" colspan="2">Asset Value</td>
            </tr>

            <xsl:for-each select="$assetAllocationArray/item">
                <tr>
                    <td class="bookletKeyColumn" ><xsl:value-of select="./assetType" /> </td>
                    <!--
					<td>
						<xsl:call-template name="dollarPercentTemplate">
							<xsl:with-param name="unit" select="assetMethod/text()" />
							<xsl:with-param name="unitValue" select="assetValue/text()" />
						</xsl:call-template>
					</td>
					-->
                    <xsl:call-template name="dollarPercentTemplateForTD">
                        <xsl:with-param name="unit" select="assetMethod/text()" />
                        <xsl:with-param name="unitValue" select="assetValue/text()" />
                    </xsl:call-template>



                </tr>
                <!-- assetValue -->
            </xsl:for-each>

            <tr>
                <td class="bookletStrongKeyColumn" >Total Asset Allocation
                </td>
                <td class="bookletStrongKeyColumn">
                    <xsl:variable name="totalAssetDollar" select='sum($assetAllocationArray/item[assetMethod/text() = "Dollar"]/assetValue)' />
                    $<xsl:value-of select="format-number( ceiling(100*$totalAssetDollar) div 100 ,'###,##0.00' )" />

                    <!--
					<xsl:call-template name="dollarPercentTemplate">
						<xsl:with-param name="unit">Dollar</xsl:with-param>
						<xsl:with-param name="unitValue" select="$totalAssetDollar" />
					</xsl:call-template>
					-->
                </td>
                <td class="bookletStrongKeyColumn">
                    <xsl:variable name="totalAssetPercent" select='sum($assetAllocationArray/item[assetMethod/text() = "Percent"]/assetValue)' />
                    <xsl:value-of select="format-number( ceiling(100*$totalAssetPercent) div 100 ,'###,##0.00' )" />

                    %
                    <!--
					<xsl:call-template name="dollarPercentTemplate">
						
						<xsl:with-param name="unit">Percent</xsl:with-param>
						<xsl:with-param name="unitValue" select="$totalAssetPercent" />
					</xsl:call-template>
					-->
                </td>
            </tr>
            <!--
			<tr>
				<td class="bookletStrongKeyColumn" >Balance<xsl:value-of select='@node' />
				</td>
				<td>$
					<xsl:variable name="productCategory" select="productCategory"/>
					<xsl:choose>
						<xsl:when test="$productCategory = 'Investment'">
							<xsl:choose>
								<xsl:when test="$isCurrent = 'true'">
									<xsl:value-of select="currentInvestmentDetails/currentBalance"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="proposedInvestmentDetails/currentBalance"/>
								</xsl:otherwise>
							</xsl:choose>
							
						</xsl:when>
						<xsl:when test="$productCategory = 'Superannuation/Pension'">
							<xsl:choose>
								<xsl:when test="$isCurrent = 'true'">
									<xsl:value-of select="currentSuperDetails/currentBalance"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="proposedSuperDetails/currentBalance"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							
						</xsl:otherwise>
					</xsl:choose>
					
				</td>
			</tr>
			-->
        </table>

    </xsl:template>

    <xsl:template name="genericReplacementCheckListAssetAllocation_old" >
        <br/>
        <table class="bookletTable">
            <tr class="bookletRowHeader">
                <td colspan="5">Asset Allocation</td>
            </tr>
            <tr>
                <td class="bookletStrongKeyColumn" rowspan="2"></td>
                <td class="bookletStrongKeyTallyColumn" colspan="2">Current</td>
                <td class="bookletStrongKeyTallyColumn" colspan="2">Proposed</td>
            </tr>
            <tr>
                <td class="bookletStrongKeyTallyColumn">($)</td>
                <td class="bookletStrongKeyTallyColumn">(%)</td>
                <td class="bookletStrongKeyTallyColumn">($)</td>
                <td class="bookletStrongKeyTallyColumn">(%)</td>
            </tr>
            <xsl:variable name="currentAssets"  select="assetAllocationDetails/currentAssetAllocation" />
            <xsl:variable name="proposedAssets" select="assetAllocationDetails/proposedAssetAllocation" />
            <xsl:for-each select="$tableDefinitions/tables/table[@name='ReplacementChecklistAssetAllocation']/tr" >
                <xsl:variable name="assetName" select="@node" />
                <tr>
                    <xsl:copy-of select="td" />
                    <td class="bookletTallyCell"><xsl:value-of select="$currentAssets/item[assetType/text() = $assetName and (assetMethod = '$' or assetMethod = 'Dollar')]/assetValue" /></td>
                    <td class="bookletTallyCell"><xsl:value-of select="$currentAssets/item[assetType/text() = $assetName and (assetMethod = '%' or assetMethod = 'Percent')]/assetValue" /></td>
                    <td class="bookletTallyCell"><xsl:value-of select="$proposedAssets/item[assetType/text() = $assetName and (assetMethod = '$' or assetMethod = 'Dollar')]/assetValue" /></td>
                    <td class="bookletTallyCell"><xsl:value-of select="$proposedAssets/item[assetType/text() = $assetName and (assetMethod = '%' or assetMethod = 'Percent')]/assetValue" /></td>
                </tr>
            </xsl:for-each>
            <!-- Gets remaining distinct names -->
            <xsl:variable name="otherAssetNames" select="distinct-values($currentAssets/item[not(assetType/text() = 
			$tableDefinitions/tables/table[@name='ReplacementChecklistAssetAllocation']/tr[@node])]/assetType
				|	$proposedAssets/item[not(assetType/text()  = 
					$tableDefinitions/tables/table[@name='ReplacementChecklistAssetAllocation']/tr[@node])]/assetType)" />
            <xsl:for-each select="$otherAssetNames">
                <xsl:variable name="otherAssetName" select="." />
                <tr>
                    <td class="bookletKeyColumn">Other - <xsl:value-of select="$otherAssetName" /></td>
                    <td class="bookletTallyCell"><xsl:value-of select="$currentAssets/item[assetType/text() = $otherAssetName and (assetMethod = '$' or assetMethod = 'Dollar')]/assetValue" /></td>
                    <td class="bookletTallyCell"><xsl:value-of select="$currentAssets/item[assetType/text() = $otherAssetName and (assetMethod = '%' or assetMethod = 'Percent')]/assetValue" /></td>
                    <td class="bookletTallyCell"><xsl:value-of select="$proposedAssets/item[assetType/text() = $otherAssetName and (assetMethod = '$' or assetMethod = 'Dollar')]/assetValue" /></td>
                    <td class="bookletTallyCell"><xsl:value-of select="$proposedAssets/item[assetType/text() = $otherAssetName and (assetMethod = '%' or assetMethod = 'Percent')]/assetValue" /></td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>

    <!--
		Prints the underlying investment details for the current and proposed investments.
	-->
    <xsl:template name="genericUnderlyingInvestmentDetails" >
        <br/>

        <table class="bookletTable">
            <tr class="bookletRowHeader">
                <td colspan="2">Underlying Investment Details</td>
            </tr>
            <tr>
                <td class="bookletStrongKeyColumn" width="50%">Current </td>
                <td class="bookletStrongKeyColumn" width="50%">Proposed</td>
            </tr>
            <tr>
                <td>
                    <xsl:call-template name="printAnUnderlyingInvestmentTable">
                        <xsl:with-param name="investmentDetails" select="currentUnderlyingInvestmentDetails" />
                        <xsl:with-param name="tableDefName" select="'Current'" />
                    </xsl:call-template>
                </td>
                <td>
                    <xsl:call-template name="printAnUnderlyingInvestmentTable">
                        <xsl:with-param name="investmentDetails" select="proposedUnderlyingInvestmentDetails" />
                        <xsl:with-param name="tableDefName" select="'Proposed'" />
                    </xsl:call-template>
                </td>
            </tr>
        </table>
        <!--
		<table class="bookletTable">
			<tr class="bookletRowHeader">
				<td colspan="4">Underlying Investment Details</td>
			</tr>
			<xsl:call-template name="printAnUnderlyingInvestmentTable">
				<xsl:with-param name="investmentDetails" select="currentUnderlyingInvestmentDetails" />
				<xsl:with-param name="tableDefName" select="'Current'" />
			</xsl:call-template>
			<xsl:call-template name="printAnUnderlyingInvestmentTable">
				<xsl:with-param name="investmentDetails" select="proposedUnderlyingInvestmentDetails" />
				<xsl:with-param name="tableDefName" select="'Proposed'" />
			</xsl:call-template>
		</table>
		-->
    </xsl:template>

    <xsl:template name="printAnUnderlyingInvestmentTable">
        <xsl:param name="investmentDetails" />
        <xsl:param name="tableDefName" />

        <table class="bookletTable">
            <tr>
                <td rowspan="2" class="bookletStrongKeyColumn" width="40%" >Investment Name</td>
                <td rowspan="2" class="bookletStrongKeyColumn" width="24%" >Balance($)</td>
                <td colspan="2" class="bookletStrongKeyColumn">MER / ICR Including Performance Fee </td>

            </tr>
            <tr>

                <td class="bookletStrongKeyColumn" width="24%">($)  </td>
                <td class="bookletStrongKeyColumn" width="12%">(%) </td>
            </tr>

            <xsl:for-each select="$investmentDetails/underlyingProductInvestment/item">
                <tr>
                    <td><xsl:value-of select="investmentName" /></td>
                    <td class="bookletTallyCell">
                        $<!--<xsl:value-of select="investmentBalanceValue" />-->

                        <xsl:call-template name="formatUnit">
                            <xsl:with-param name="unitValue" select="investmentBalanceValue" />
                        </xsl:call-template>
                    </td>

                    <!--
					<xsl:call-template name="dollarPercentTemplateForTD">
						<xsl:with-param name="unit" select="investmentMerMethod/text()" />
						<xsl:with-param name="unitValue" select="investmentMerValue/text()" />
					</xsl:call-template>
					
					-->

                    <xsl:variable name="isMerMethodExist" select="string-length(investmentMerMethod) > 0" />
                    <xsl:if test="$isMerMethodExist">
                        <xsl:call-template name="dollarPercentTemplateForTD">
                            <xsl:with-param name="unit" select="investmentMerMethod/text()" />
                            <xsl:with-param name="unitValue" select="investmentMerValue/text()" />
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="not($isMerMethodExist)">
                        <xsl:call-template name="dollarPercentTemplateForTD">
                            <xsl:with-param name="unit">Percent</xsl:with-param>
                            <xsl:with-param name="unitValue" select="investmentMerValue/text()" />
                        </xsl:call-template>
                    </xsl:if>


                </tr>
            </xsl:for-each>


            <tr>
                <td class="bookletStrongKeyColumn">Total</td>
                <td class="bookletStrongKeyColumn"><!--<xsl:value-of select="$investmentDetails/totalBalance" />-->
                    $<!--<xsl:value-of select="format-number( ceiling(100 * $investmentDetails/totalBalance ) div 100 ,'###,##0.00' )" />-->
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$investmentDetails/totalBalance" />
                    </xsl:call-template>
                </td>
                <td class="bookletStrongKeyColumn"><!--<xsl:value-of select="$investmentDetails/totalMerValue" />-->
                    $<!--<xsl:value-of select="format-number( ceiling(100 * $investmentDetails/totalMerValue ) div 100 ,'###,##0.00' )" />-->
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$investmentDetails/totalMerValue" />
                    </xsl:call-template>
                </td>
                <td class="bookletStrongKeyColumn"><!--<xsl:value-of select="$investmentDetails/totalMerPercentage" />-->
                    <!--<xsl:value-of select="format-number( ceiling(100 * $investmentDetails/totalMerPercentage ) div 100 ,'###,##0.00' )" />%-->
                    <xsl:call-template name="formatUnitPercent">
                        <xsl:with-param name="unitValue" select="$investmentDetails/totalMerPercentage" />
                    </xsl:call-template>%
                </td>
            </tr>
        </table>
    </xsl:template>
    <!-- Prints all the investment details and the summary row. -->
    <xsl:template name="printAnUnderlyingInvestmentTable_old">
        <xsl:param name="investmentDetails" />
        <xsl:param name="tableDefName" />

        <tr>
            <td class="bookletStrongKeyColumn" rowspan="2"><b><xsl:value-of select="$tableDefName" /> Underlying Investment name(s):</b></td>
            <td class="bookletStrongKeyTallyColumn" rowspan="2">Balance ($)</td>
            <td class="bookletStrongKeyTallyColumn" colspan="2">MER / ICR (Including Performance Fee)</td>
        </tr>
        <tr>
            <td class="bookletStrongKeyTallyColumn">($)</td>
            <td class="bookletStrongKeyTallyColumn">(%)</td>
        </tr>
        <xsl:for-each select="$investmentDetails/underlyingProductInvestment/item">
            <tr>
                <td><xsl:value-of select="investmentName" /></td>
                <td class="bookletTallyCell"><xsl:value-of select="investmentBalanceValue" /></td>
                <xsl:choose>
                    <xsl:when test="investmentMerMethod/text() = '$' or investmentMerMethod/text() = 'Dollar'">
                        <td class="bookletTallyCell"><xsl:value-of select="investmentMerValue" /></td>
                        <td></td>
                    </xsl:when>
                    <xsl:otherwise>
                        <td></td>
                        <td class="bookletTallyCell"><xsl:value-of select="investmentMerValue" /></td>
                    </xsl:otherwise>
                </xsl:choose>
            </tr>
        </xsl:for-each>
        <tr>
            <td class="bookletStrongKeyColumn">Total (Balance and Weighted MER)</td>
            <td class="bookletTallyCell"><!--<xsl:value-of select="$investmentDetails/totalBalance" />-->
                <xsl:value-of select="format-number( ceiling(100 * $investmentDetails/totalBalance ) div 100 ,'###,##0.00' )" />
            </td>
            <td class="bookletTallyCell"><!--<xsl:value-of select="$investmentDetails/totalMerValue" />-->
                <xsl:value-of select="format-number( ceiling(100 * $investmentDetails/totalMerValue ) div 100 ,'###,##0.00' )" />
            </td>
            <td class="bookletTallyCell"><!--<xsl:value-of select="$investmentDetails/totalMerPercentage" />-->
                <xsl:value-of select="format-number( ceiling(100 * $investmentDetails/totalMerPercentage ) div 100 ,'###,##0.00' )" />
            </td>
        </tr>
    </xsl:template>

    <!--
		Prints the benefits / justifications table with text.
	-->
    <xsl:template name="printBenefitsJustifications">
        <xsl:param name="theText" />
        <xsl:param name="type" />
        <xsl:param name="unableToAccessInfoFlag" />
        <xsl:param name="Notes" />
        <br/>
        <table class="bookletTable">
            <tr class="bookletRowHeader">
                <td colspan="2">Outline the benefit(s)/justification(s) to the customer of replacing existing <xsl:value-of select="$type" />(s):</td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Details</td><td><xsl:value-of select="$theText" /></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Unable to access all information?</td>
                <td>
                    <xsl:call-template name="yesNoTemplate" >
                        <xsl:with-param name="boolValue" select="$unableToAccessInfoFlag/text()" />
                    </xsl:call-template>
                </td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Notes</td>
                <td><xsl:value-of select="$Notes" /></td>
            </tr>
        </table>
    </xsl:template>

    <!--
		Prints the notes section.
	-->
    <xsl:template name="printNotes">
        <xsl:param name="theText" />
        <br/>
        <!--
		<table class="bookletTable">
			<tr>
				<td><b>Notes</b><br/><xsl:value-of select="$theText" /></td>
			</tr>
		</table>
		-->
    </xsl:template>

    <!--
		END OF THE UTILITY SECTION FOR REPLACEMENT SECTIONS
	-->


    <!--
		BEGIN ALL UTILITY TEMPLATES AND TABLE DEFINITIONS
	-->

    <!--
		Handles the formatting for special cells within the Income Stream Details table
	-->
    <xsl:template name="printNodeValue">
        <xsl:param name="theNode" />
        <xsl:choose>
            <xsl:when test="$theNode[contains(local-name(), 'Rate')]">
                <xsl:call-template name="dollarPercentTemplate" >
                    <xsl:with-param name="unit" select="'Percent'" />
                    <xsl:with-param name="unitValue" select="$theNode/text()" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$theNode[@type = 'Decimal']">
                <xsl:call-template name="dollarPercentTemplate" >
                    <xsl:with-param name="unit" select="'Dollar'" />
                    <xsl:with-param name="unitValue" select="$theNode/text()" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$theNode[@type = 'Boolean']">
                <xsl:call-template name="yesNoTemplate" >
                    <xsl:with-param name="boolValue" select="$theNode/text()" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$theNode/text()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Translates yesNo into a value -->
    <xsl:template name="yesNoTemplate" >
        <xsl:param name="boolValue" />
        <xsl:choose>
            <xsl:when test="$boolValue = 'true'">
                Yes
            </xsl:when>
            <xsl:when test="$boolValue = 'false'">
                No
            </xsl:when>
            <xsl:otherwise>

            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Translates TW Date into a value (DD-MM-YYYY)-->
    <xsl:template name="formatTWDate" >
        <xsl:param name="dateValue" />
        <xsl:if test="$dateValue">
            <xsl:value-of select='substring($dateValue, 9, 2)' />-<xsl:value-of select='substring($dateValue, 6, 2)' />-<xsl:value-of select='substring-before($dateValue, "/")' />
        </xsl:if>
    </xsl:template>

    <!-- formats a number as either a $value or value% -->
    <xsl:template name="dollarPercentTemplate">
        <xsl:param name="unit" />
        <xsl:param name="unitValue" />
        <xsl:choose>
            <xsl:when test="$unit = 'Dollar'"> <!--  and $unitValue != ''  -->
                $<!--<xsl:value-of select="$unitValue" />-->
                <xsl:call-template name="formatUnit">
                    <xsl:with-param name="unitValue" select="$unitValue" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$unit = 'Percent'">
                <xsl:call-template name="formatUnitPercent">
                    <xsl:with-param name="unitValue" select="$unitValue" />
                </xsl:call-template>%
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="formatUnit">
                    <xsl:with-param name="unitValue" select="$unitValue" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="dollarPercentTemplateForTD">
        <xsl:param name="unit" />
        <xsl:param name="unitValue" />
        <xsl:choose>
            <xsl:when test="$unit = 'Dollar'">
                <td>
                    $<!--<xsl:value-of select="$unitValue" />-->
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$unitValue" />
                    </xsl:call-template>
                </td>
                <td></td>
                <!--$<xsl:value-of select='format-number($unitValue, "#,###,###.000000")' />-->
            </xsl:when>
            <xsl:when test="$unit = 'Percent'">
                <td></td>
                <td>
                    <!--<xsl:value-of select="$unitValue" />-->
                    <xsl:call-template name="formatUnitPercent">
                        <xsl:with-param name="unitValue" select="$unitValue" />
                    </xsl:call-template>
                    %
                </td>

            </xsl:when>
            <xsl:otherwise>
                <td><!--<xsl:value-of select="$unitValue" />-->
                    <xsl:call-template name="formatUnit">
                        <xsl:with-param name="unitValue" select="$unitValue" />
                    </xsl:call-template>
                </td>
                <td></td>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- formatUnitTemplate -->
    <xsl:template name="formatUnit">
        <xsl:param name="unitValue" />
        <xsl:variable name="unitValue" select="string($unitValue)" />
        <xsl:variable name="isValid" select="string-length($unitValue) > 0" />
        <!--original unit : <xsl:value-of select="$unitValue" /> <br />-->

        <xsl:if test="$isValid">
            <xsl:value-of select='format-number( ceiling(100 * (number($unitValue) ) ) div 100 , "###,##0.00####")'/>
        </xsl:if>
        <xsl:if test="not($isValid)">0.00</xsl:if>
    </xsl:template>

    <!-- formatUnitTemplate -->
    <xsl:template name="formatUnitPercent">
        <xsl:param name="unitValue" />
        <xsl:variable name="unitValue" select="string($unitValue)" />
        <xsl:variable name="isValid" select="string-length($unitValue) > 0" />
        <!--original unit : <xsl:value-of select="$unitValue" /> <br />-->

        <xsl:if test="$isValid">
            <xsl:value-of select='format-number( ceiling(1000000 * (number($unitValue) ) ) div 1000000 , "###,##0.00####")'/>
        </xsl:if>
        <xsl:if test="not($isValid)">0.00</xsl:if>
    </xsl:template>


    <!-- ReplacementChecklistQuickPlanSuper -->
    <xsl:template match="checklistQuickPlanSuper" >
        <br />
        <table class="bookletTable">
            <tr class="bookletRowHeader">
                <td colspan="4">Warning for replacing existing product</td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Reduce potential for Investment Growth?</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./reducedGrowthFlag/text()" /></xsl:call-template> </td>
                <td class="bookletKeyColumn">Increase in potential volatility of recommended investment</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./volitilityFlag/text()" /></xsl:call-template></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Existing fund with Term Deposit rate will be reduced</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./reducedFundRateFlag/text()" /></xsl:call-template></td>
                <td class="bookletKeyColumn">Recommended product has higher Ongoing Fees</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./higherOngoingFeesFlag/text()" /></xsl:call-template></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Less investment options than existing investment</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./lessOptionsFlag/text()" /></xsl:call-template></td>
                <td class="bookletKeyColumn">Does Recommended product have higher fees than existing products?</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./higherFeesFlag/text()" /></xsl:call-template></td>
            </tr>			<tr>
            <td class="bookletKeyColumn">Exit Fees apply</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./entryFees/text()" /></xsl:call-template></td>
            <td class="bookletKeyColumn" colspan="2">How does the recommended product/policy better meet the customer documented needs?</td>
        </tr>
            <tr>
                <xsl:variable name="forfeitLifeVar" select="./forfeitLife" />

                <td class="bookletKeyColumn">Forfeit Life Insurance of:</td><td><xsl:value-of select='format-number($forfeitLifeVar, "#,###,###.00")' /></td>
                <td rowspan="3" colspan="2"><xsl:value-of select="betterProduct" /></td>
            </tr>
            <tr>
                <xsl:variable name="forfeitTPDVar" select="./forfeitTPD" />
                <td class="bookletKeyColumn">Forfeit TPD Insurance of:</td><td><xsl:value-of select='format-number($forfeitTPDVar, "#,###,###.00")' /></td>
            </tr>
            <tr>
                <xsl:variable name="forfeitIPVar" select="./forfeitIP" />
                <td class="bookletKeyColumn">Forfeit IP cover with monthly benefit of:</td><td><xsl:value-of select='format-number($forfeitIPVar, "#,###,###.00")' /></td>
            </tr>
        </table>
    </xsl:template>

    <!-- ReplacementChecklistQuickPlanInvest -->
    <xsl:template match="checklistQuickPlanInvest" >
        <br />
        <table class="bookletTable">
            <tr class="bookletRowHeader">
                <td colspan="4">Warning for replacing existing product</td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Potential CGT liability</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./cgtFlag/text()" /></xsl:call-template> </td>
                <td class="bookletKeyColumn">Increase in potential volatility of recommended investment</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./volitilityFlag/text()" /></xsl:call-template></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Reduced Potential for Capital Growth</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./reducedGrowthFlag/text()" /></xsl:call-template> </td>
                <td class="bookletKeyColumn">Recommended product has higher Ongoing Fees</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./higherOngoingFeesFlag/text()" /></xsl:call-template></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Existing fund with Term Deposit rate will be reduced</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./reducedFundRateFlag/text()" /></xsl:call-template> </td>
                <td class="bookletKeyColumn">Does Recommended product have higher fees than existing products?</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./higherFeesFlag/text()" /></xsl:call-template></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">Less investment options than existing investment</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./lessOptionsFlag/text()" /></xsl:call-template> </td>
                <td colspan="2"></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn">How does the recommended product/policy better meet the customers documented needs?</td>
                <td colspan="3"><xsl:value-of select="./betterProduct" /></td>
            </tr>
        </table>
    </xsl:template>


    <!-- ReplacementChecklistQuickPlanInsurance -->
    <xsl:template match="checklistQuickPlanInsurance" >
        <br />
        <table class="bookletTable">
            <tr class="bookletRowHeader">
                <td colspan="4">Warning for replacing existing product</td>
            </tr>
            <tr>
                <td class="bookletKeyColumn" colspan="3">Does recommended product have higher fees than existing products?</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./higherProductFeesFlag/text()" /></xsl:call-template></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn" colspan="4">How does the recommended policy better meets the Customers documented needs</td>
            </tr>
            <tr>
                <td colspan="4"><xsl:value-of select="./betterProduct/text()" /></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn" colspan="3">Paying insurance premiums with your superannuation balance</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./payWithSuperFlag/text()" /></xsl:call-template></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn" colspan="3">Expose to a period of no cover</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./noCoverFlag/text()" /></xsl:call-template></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn" colspan="3">Subject to financial and/or medical underwriting</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./medicalUnderwritingFlag/text()" /></xsl:call-template></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn" colspan="3">13 month suicide exclusion</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./suicideExclusionFlag/text()" /></xsl:call-template></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn" colspan="3">Existing IP has agreed benefit. Replacement IP has indemnity benefit.</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./indemnityBenefitFlag/text()" /></xsl:call-template></td>
            </tr>
            <tr>
                <td class="bookletKeyColumn" colspan="3">Existing TPD has 'own occupation' definition. Replacement TPD has 'any occupation' definition.</td><td><xsl:call-template name="yesNoTemplate"><xsl:with-param name="boolValue" select="./occupationDefinitionFlag/text()" /></xsl:call-template></td>
            </tr>
        </table>
    </xsl:template>



    <!--
		Define the tables that contain the list of nodes to look up in a context.
	-->
    <xsl:variable name="tableDefinitions">
        <tables>
            <!-- Personal Assumes the context is within an Client Item -->
            <table name="Personal">
                <tr node="clientID"><td class="bookletKeyColumn">CIS Key</td></tr>
                <tr node="title"><td class="bookletKeyColumn">Title (e.g. Mr, Mrs)</td></tr>
                <tr node="lastName"><td class="bookletKeyColumn">Surname</td></tr>
                <tr node="firstName"><td class="bookletKeyColumn">Given name(s)</td></tr>
                <tr node="preferredName"><td class="bookletKeyColumn">Preferred Name</td></tr>
                <tr node="gender"><td class="bookletKeyColumn">Gender</td></tr>
                <tr node="maritalStatus"><td class="bookletKeyColumn">Marital Status</td></tr>
                <tr node="dateOfBirth"><td class="bookletKeyColumn">Date of Birth (DD/MM/YYYY)</td></tr>
                <!-- Expected Retirement Age is missing from object. -->
                <tr node="expectedRetirementAge"><td class="bookletKeyColumn">Expected Retirement Age</td></tr>
                <tr node="relationship"><td class="bookletKeyColumn">Relationship Customers 1 &amp; 2</td></tr>
                <tr node="homeAddress"><td class="bookletKeyColumn">Residential Address</td></tr>
                <tr node="postalAddress"><td class="bookletKeyColumn">Postal Address</td></tr>
                <tr node="homePhone"><td class="bookletKeyColumn">Home Telephone</td></tr>
                <tr node="workPhone"><td class="bookletKeyColumn">Business Telephone</td></tr>
                <tr node="mobilePhone"><td class="bookletKeyColumn">Mobile</td></tr>
                <tr node="email"><td class="bookletKeyColumn">Email Address</td></tr>
                <tr node="fax"><td class="bookletKeyColumn">Facsimile</td></tr>
                <!-- Preferred Contact is missing from object. -->
                <tr node="preferredContactMethod"><td class="bookletKeyColumn">Preferred Contact Method</td></tr>
                <tr node="occupation"><td class="bookletKeyColumn">Occupation</td></tr>
                <tr node="employmentMode"><td class="bookletKeyColumn">Employment Status</td></tr>
                <tr node="hoursPerWeek"><td class="bookletKeyColumn">Hours Per Week</td></tr>
                <tr node="employerName"><td class="bookletKeyColumn">Employer's Name</td></tr>
                <tr node="address"><td class="bookletKeyColumn">Employer's Address</td></tr>
                <!-- Date of Employment is missing from object. -->
                <tr node="dateEmploymentCommenced"><td class="bookletKeyColumn">Date Employment Commenced</td></tr>
                <!-- Salary Packaging is missing from object. -->
                <tr node="salaryPackaging"><td class="bookletKeyColumn">Is salary packaging available?</td></tr>
                <!-- Self employed is missing from object. -->
                <tr node="selfEmployed"><td class="bookletKeyColumn">If self-employed, what is the business structure?</td></tr>
                <tr node="taxPurposeAustraliaFlag"><td class="bookletKeyColumn">Are you an Australian resident for taxation purposes?</td></tr>
                <tr node="taxPurposeCountry"><td class="bookletKeyColumn">If no, which country?</td></tr>
                <!-- Fluent in English is missing from object. -->
                <tr node="fluentEnglish"><td class="bookletKeyColumn">Are you fluent in English?</td></tr>
                <!-- Interpreter is missing from object. -->
                <tr node="Interpreter"><td class="bookletKeyColumn">Do you require the assistance of an interpreter?</td></tr>
            </table>
            <!-- Income assumes that the context is within an IncomeExpenseDetail. -->
            <table name="income">
                <tr typePrefix="Income - "><td class="bookletKeyColumn">Salary and/or wages (exclude SG contributions)</td></tr>
                <tr typePrefix="Business Overheads"><td class="bookletKeyColumn">Business Overheads</td></tr>
                <tr typePrefix="Car/"><td class="bookletKeyColumn">Car/Boat/Transport</td></tr>
                <tr typePrefix="Credit Cards"><td class="bookletKeyColumn">Credit Cards</td></tr>
                <tr typePrefix="Dependant"><td class="bookletKeyColumn">Dependant(s)/Maintenance Payments</td></tr>
                <tr typePrefix="Donations"><td class="bookletKeyColumn">Donations (Charity/Foundation)</td></tr>
                <tr typePrefix="Education"><td class="bookletKeyColumn">Education</td></tr>
                <tr typePrefix="Entertainment"><td class="bookletKeyColumn">Entertainment</td></tr>
                <tr typePrefix="Holidays"><td class="bookletKeyColumn">Holidays</td></tr>
                <tr typePrefix=" utilitites"><td class="bookletKeyColumn">utilitites</td></tr>
                <tr typePrefix="Household"><td class="bookletKeyColumn">Household (rates, utilitites, food, etc.)</td></tr>
                <tr typePrefix="Insurance Premiums"><td class="bookletKeyColumn">Insurance Premiums (General/Life)</td></tr>
                <tr typePrefix="Medical/Dental"><td class="bookletKeyColumn">Medical/Dental</td></tr>
                <tr typePrefix="Other Debt Repayments"><td class="bookletKeyColumn">Other Debt Repayments</td></tr>
                <tr typePrefix="Personal (e.g. Clothing)"><td class="bookletKeyColumn">Personal (e.g. Clothing)</td></tr>
                <tr typePrefix="Rent/Home Mortgage"><td class="bookletKeyColumn">Rent/Home Mortgage</td></tr>
                <tr typePrefix="Personal (e.g. Clothing)"><td class="bookletKeyColumn">Personal (e.g. Clothing)</td></tr>
                <tr typePrefix="Superannuation Contributions"><td class="bookletKeyColumn">Superannuation Contributions</td></tr>
                <tr typePrefix=" fares"><td class="bookletKeyColumn">fares</td></tr>
                <tr typePrefix="Transport (e.g. car(s), fares)"><td class="bookletKeyColumn">Transport (e.g. car(s), fares)</td></tr>
            </table>
            <!-- Expense assumes that the context is within an IncomeExpenseDetail. -->
            <table name="expenses">
                <tr typePrefix="Expense"><td class="bookletKeyColumn">Expense</td></tr>
                <tr typePrefix="Business Overheads"><td class="bookletKeyColumn">Business Overheads</td></tr>
                <tr typePrefix="Car/"><td class="bookletKeyColumn">Car/Boat/Transport</td></tr>
                <tr typePrefix="Credit Cards"><td class="bookletKeyColumn">Credit Cards</td></tr>
                <tr typePrefix="Dependant"><td class="bookletKeyColumn">Dependant(s)/Maintenance Payments</td></tr>
                <tr typePrefix="Donations"><td class="bookletKeyColumn">Donations (Charity/Foundation)</td></tr>
                <tr typePrefix="Education"><td class="bookletKeyColumn">Education</td></tr>
                <tr typePrefix="Entertainment"><td class="bookletKeyColumn">Entertainment</td></tr>
                <tr typePrefix="Holidays"><td class="bookletKeyColumn">Holidays</td></tr>
                <tr typePrefix=" utilitites"><td class="bookletKeyColumn">utilitites</td></tr>
                <tr typePrefix="Household"><td class="bookletKeyColumn">Household (rates, utilitites, food, etc.)</td></tr>
                <tr typePrefix="Insurance Premiums"><td class="bookletKeyColumn">Insurance Premiums (General/Life)</td></tr>
                <tr typePrefix="Medical/Dental"><td class="bookletKeyColumn">Medical/Dental</td></tr>
                <tr typePrefix="Other Debt Repayments"><td class="bookletKeyColumn">Other Debt Repayments</td></tr>
                <tr typePrefix="Personal (e.g. Clothing)"><td class="bookletKeyColumn">Personal (e.g. Clothing)</td></tr>
                <tr typePrefix="Rent/Home Mortgage"><td class="bookletKeyColumn">Rent/Home Mortgage</td></tr>
                <tr typePrefix="Personal (e.g. Clothing)"><td class="bookletKeyColumn">Personal (e.g. Clothing)</td></tr>
                <tr typePrefix="Superannuation Contributions"><td class="bookletKeyColumn">Superannuation Contributions</td></tr>
                <tr typePrefix=" fares"><td class="bookletKeyColumn">fares</td></tr>
                <tr typePrefix="Transport (e.g. car(s), fares)"><td class="bookletKeyColumn">Transport (e.g. car(s), fares)</td></tr>
            </table>
            <table name="IncomeStream">
                <tr node="owner"><td class="bookletKeyColumn">Owner</td></tr>
                <tr node="fundName"><td class="bookletKeyColumn">Fund name</td></tr>
                <tr node="pensionAnnuityType"><td class="bookletKeyColumn">Pension / annuity type</td></tr>
                <tr node="complyingCentrelink"><td class="bookletKeyColumn">Complying (Centrelink)</td></tr>
                <tr node="dateOfPurchase"><td class="bookletKeyColumn">Date of purchase</td></tr>
                <tr node="investmentAmount"><td class="bookletKeyColumn">Investment amount</td></tr>
                <tr node="currentValue"><td class="bookletKeyColumn">Current value</td></tr>
                <tr node="currentUnits"><td class="bookletKeyColumn">Current units</td></tr>
                <tr node="centreLinksDeductibleAmount"><td class="bookletKeyColumn">Centrelink deductible amount</td></tr>
                <tr node="taxFreeComponent"><td class="bookletKeyColumn">Tax free component</td></tr>
                <tr node="taxableComponent"><td class="bookletKeyColumn">Taxable component </td></tr>
                <tr node="income"><td class="bookletKeyColumn">Income p.a.</td></tr>
                <tr node="minMaxSpecified"><td class="bookletKeyColumn">Indicate min/max/specified</td></tr>
                <tr node="paymentFrequency"><td class="bookletKeyColumn">Payment frequency</td></tr>
                <tr node="termOfPensionAnnuity"><td class="bookletKeyColumn">Term of pension annuity</td></tr>
                <tr node="indexed"><td class="bookletKeyColumn">Index</td></tr>
                <tr node="indexationRate"><td class="bookletKeyColumn">Indexation Rate</td></tr>
                <tr node="residuaryCapitalValue"><td class="bookletKeyColumn">Residuary capital value</td></tr>
                <tr node="reversionary"><td class="bookletKeyColumn">Reversionary</td></tr>
                <tr node="deathBenefitNomination"><td class="bookletKeyColumn">Death benefit nomination</td></tr>
            </table>
            <table name="EarlyRetirement">
                <tr node="employmentCommencementDate"><td class="bookletKeyColumn">Employment commencement date</td></tr>
                <tr node="dateEmploymentToCease"><td class="bookletKeyColumn">Date employment to cease</td></tr>
                <tr node="earlyRetirementPaymentAmount"><td class="bookletKeyColumn">Amount of redundancy / early retirement payment</td></tr>
                <tr node="paymentForUnusedAnnualLeave"><td class="bookletKeyColumn">Payment for unused annual leave</td></tr>
                <tr node="paymentForUnusedLongServiceLeave"><td class="bookletKeyColumn">Payment for unused long service leave</td></tr>
                <tr node="exitSuperannuationFund"><td class="bookletKeyColumn">Will you have to exit the superannuation fund?</td></tr>
            </table>
            <table name="SuperReplacementChecklistFeesTable">
                <tr node="Entry Fee"><td class="bookletKeyColumn">Entry Fee</td></tr>
                <tr node="Exit Fees"><td class="bookletKeyColumn">Exit Fees</td></tr>
                <tr node="Buy / Sell / Spread"><td class="bookletKeyColumn">Buy / Sell / Spread</td></tr>
                <tr node="Administration Fee"><td class="bookletKeyColumn">Administration Fee</td></tr>
                <tr node="Switch Fee"><td class="bookletKeyColumn">Switching Fee</td></tr>
                <tr node="Advice Fee"><td class="bookletKeyColumn">Advice Fee</td></tr>
            </table>
            <!-- This table below contains an additional column that only applies to investments -->
            <table name="InvestmentReplacementChecklistFeesTable">
                <tr node="Entry Fee"><td class="bookletKeyColumn">Entry Fee</td></tr>
                <tr node="Exit Fee"><td class="bookletKeyColumn">Exit Fee</td></tr>
                <tr node="Buy / Sell / Spread"><td class="bookletKeyColumn">Buy / Sell / Spread</td></tr>
                <tr node="Administration Fee"><td class="bookletKeyColumn">Administration Fee</td></tr>
                <tr node="Switching Fee"><td class="bookletKeyColumn">Switching Fee</td></tr>
                <tr node="Advice Fee"><td class="bookletKeyColumn">Advice Fee</td></tr>
                <tr node="MER / ICR"><td class="bookletKeyColumn">MER / ICR</td></tr>
            </table>
            <table name="ReplacementChecklistAssetAllocation">
                <tr node="Cash"><td class="bookletKeyColumn">Cash</td></tr>
                <tr node="Fixed Interest"><td class="bookletKeyColumn">Fixed Interest</td></tr>
                <tr node="Australian Shares"><td class="bookletKeyColumn">Australian Shares</td></tr>
                <tr node="International Shares"><td class="bookletKeyColumn">International Shares</td></tr>
                <tr node="Property"><td class="bookletKeyColumn">Property AdviceReq</td></tr>
            </table>
        </tables>
    </xsl:variable>

</xsl:stylesheet>
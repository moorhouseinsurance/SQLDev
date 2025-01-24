<?xml version="1.0" encoding="utf-8"?>
<screen name="frmClmSum.tst" type="NextPrevious">
    <backColor>
        <r>212</r>
        <g>208</g>
        <b>200</b>
    </backColor>
    <boundScreen />
    <caption>Claim Summary</caption>
    <description>Claim Summary</description>
    <screenType>0</screenType>
    <projectType>1</projectType>
    <postQuoteNavigationDuplicated>False</postQuoteNavigationDuplicated>
    <foreColor>
        <r>0</r>
        <g>0</g>
        <b>0</b>
    </foreColor>
    <height>285</height>
    <parentID />
    <text>Liability: Claim Summary</text>
    <width>477</width>
    <defaultFont>
        <bold>False</bold>
        <fontName>Tahoma</fontName>
        <formLoadCode />
        <formValidateCode />
        <italic>False</italic>
        <size>8.25</size>
        <strikeout>False</strikeout>
        <underline>False</underline>
    </defaultFont>
    <controls>
        <control name="grpClaimSummary" type="GroupBox">
            <backColor>
                <r>212</r>
                <g>208</g>
                <b>200</b>
            </backColor>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>156</height>
            <left>10</left>
            <font>
                <bold>True</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <rightToLeft>0</rightToLeft>
            <tabIndex>2</tabIndex>
            <text>Claim Summary</text>
            <top>50</top>
            <width>444</width>
            <controls>
                <control name="cmdClaimRemove" type="WisButton">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <description>Claim Remove</description>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>363</left>
                    <listView>lvwClmSumList</listView>
                    <top>123</top>
                    <tabIndex>6</tabIndex>
                    <type>5</type>
                    <text>    &amp;Remove</text>
                    <width>75</width>
                </control>
                <control name="cmdClaimEdit" type="WisButton">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <description>Claim Edit</description>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>282</left>
                    <listView>lvwClmSumList</listView>
                    <top>123</top>
                    <tabIndex>5</tabIndex>
                    <type>4</type>
                    <text>  &amp;Edit</text>
                    <width>75</width>
                </control>
                <control name="cmdClaimAdd" type="WisButton">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <description>Claim Add</description>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>201</left>
                    <listView>lvwClmSumList</listView>
                    <top>123</top>
                    <tabIndex>4</tabIndex>
                    <type>3</type>
                    <text>  &amp;Add</text>
                    <width>75</width>
                </control>
                <control name="lvwClmSumList" type="WisListView">
                    <columns>
                        <column>
                            <text>Date</text>
                            <Width>67</Width>
                            <bindControl>mskDate</bindControl>
                        </column>
                        <column>
                            <text>Type</text>
                            <Width>176</Width>
                            <bindControl>cboType</bindControl>
                        </column>
                        <column>
                            <text>Paid (£)</text>
                            <Width>94</Width>
                            <bindControl>cfdPaid</bindControl>
                        </column>
                        <column>
                            <text>Outstanding (£)</text>
                            <Width>93</Width>
                            <bindControl>cfdOutstanding</bindControl>
                        </column>
                    </columns>
                    <backColor>
                        <r>255</r>
                        <g>255</g>
                        <b>255</b>
                    </backColor>
                    <borderStyle>1</borderStyle>
                    <boundScreen>MLIAB\frmClmDtail.tst</boundScreen>
                    <description>Claim Summary List</description>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>97</height>
                    <left>6</left>
                    <font>
                        <bold>False</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>3</tabIndex>
                    <text />
                    <top>20</top>
                    <width>432</width>
                    <controls />
                </control>
            </controls>
        </control>
        <control name="optIncidents" type="tgsYesNo">
            <LostFocusCode />
            <GotFocusCode />
            <ClickCode />
            <enableControls>
                <enableControl>
                    <boundScreen>MLIAB\frmClmSum.tst</boundScreen>
                    <control>grpClaimSummary</control>
                    <enable>True</enable>
                </enableControl>
            </enableControls>
            <displayPages>
                <displayPage>
                    <pageName>frmClmDtail.tst</pageName>
                    <display>True</display>
                </displayPage>
            </displayPages>
            <backColor>
                <r>212</r>
                <g>208</g>
                <b>200</b>
            </backColor>
            <borderStyle>0</borderStyle>
            <boundScreen />
            <columnName>INCIDENTS</columnName>
            <description>Have you had any losses or incidents</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>27</height>
            <left>361</left>
            <font>
                <bold>False</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <linkedData />
            <rightToLeft>0</rightToLeft>
            <tabIndex>1</tabIndex>
            <text />
            <top>20</top>
            <width>93</width>
            <showData />
            <objectID>0</objectID>
            <longPropertyID>0</longPropertyID>
            <defaultValue />
            <showHelpText>False</showHelpText>
            <helpText />
            <required>True</required>
            <displayOnWebpage>True</displayOnWebpage>
            <alwaysVisible>True</alwaysVisible>
            <controls />
        </control>
        <control name="WisLabel1" type="WisLabel">
            <sumTotalControls />
            <backColor>
                <r>212</r>
                <g>208</g>
                <b>200</b>
            </backColor>
            <borderStyle>0</borderStyle>
            <boundScreen />
            <boundTransform />
            <description>optIncidents</description>
            <maximumTotal>0</maximumTotal>
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>30</height>
            <left>10</left>
            <font>
                <bold>True</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <rightToLeft>0</rightToLeft>
            <tabIndex>0</tabIndex>
            <text>Have you had any losses or incidents that have or could have given rise to claims in the past 5 years?</text>
            <textAlign>1</textAlign>
            <top>17</top>
            <width>326</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
    </controls>
    <generalSummary>
        <columns />
    </generalSummary>
    <formValidation />
    <hideClaim />
</screen>
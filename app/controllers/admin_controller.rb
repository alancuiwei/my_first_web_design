#encoding: utf-8
class AdminController < ApplicationController
  Time::DATE_FORMATS[:stamp] = '%Y-%m-%d'
  def index
    if session[:webusername]=="admin" || session[:webusername]=="blog"
      @webusers=Webuser.all
      @hash={}
      for i in 0..@webusers.size-1
        @userfinancedata=User_finance_data.find_by_username(@webusers[i].username)
        if @userfinancedata!=nil
        @hash.store(@webusers[i].username,[@userfinancedata.risk_productid,@userfinancedata.risk_score])
        else
          @hash.store(@webusers[i].username,[nil,nil])
        end
      end
      @blogs=Blog.all
      @activity=Activity.all
      @pace=Pace.all
      @press=Press.all
      @methodology=Methodology.all
      @productcompany=Productcompany.all
      @salescompany=Salescompany.all
      @category1=Admin_asset_type_l1.all
      @category2=Admin_asset_type_l2.all
      @financial=Financial.all
      @expensetype=Admin_expense_type_month.all
      @incometype=Admin_income_type_month.all
      @assettype=Admin_asset_type.all
      @debttype=Admin_debt_type.all
      @moonlite=Admin_moonlite_type.all
      @indicators=Admin_finacialindicators.all
      @incomeannual=Admin_income_type_annual.all
      @expenseannual=Admin_expense_type_annual.all
      @risktype=Admin_risktolerance_type.all
      @fundproduct=Fund_product.all
      @average=Average_return_rate.all
      @rank=Rank.all
      #user
      @hash_password={}
      @hash_remind={}
      @hash_confirm={}
      @webusers.each do |w|
        if w.username!=nil && w.username!=""
        @hash_password.store(w.id,decode(w.password))
        else
          @hash_password.store(w.id,nil)
        end
      end
    else
      redirect_to(:controller=>"home")
    end
  end

  def rankconfig
    if params[:id]!="0"
      @rank=Rank.find_by_id(params[:id])
    else
      @rank=Rank.limit(1)
    end
  end

  def rankconfigajax
    if params[:id]=="0"
      Rank.new do |p|
        p.productid=params[:productid]
        p.date=params[:date]
        p.rank_num=params[:rank_num]
        p.total_num=params[:total_num]
        p.years=params[:years]
        p.save
      end
      render :json => "s1".to_json
    else
      @rank=Rank.find_by_id(params[:id])
      @rank.update_attributes(:productid=>params[:productid],:date=>params[:date],:rank_num=>params[:rank_num],:total_num=>params[:total_num],:years=>params[:years])
      render :json => "s2".to_json
    end
  end
  def rankdeleteajax
    @rank=Rank.find_by_id(params[:id])
    if @rank!=nil
      if @rank.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def fundproductconfig
    if params[:id]!="0"
      @fundproduct=Fund_product.find_by_id(params[:id])
    else
      @fundproduct=Fund_product.limit(1)
    end
  end

  def fundproductconfigajax
    @fundproduct=Fund_product.find_by_productname(params[:productname])
    if @fundproduct==nil
      Fund_product.new do |b|
        b.productid=params[:productid]
        b.productname=params[:productname]
        b.L2_typeid=params[:L2_typeid]
        b.L2_typename=params[:L2_typename]
        b.internet_product=params[:internet_product]
        b.institution=params[:institution]
        b.product_code=params[:product_code]
        b.min_purchase_account=params[:min_purchase_account]
        b.create_date=params[:create_date]
        b.fund_size=params[:fund_size]
        b.other_usage=params[:other_usage]
        b.official_link=params[:official_link]
        b.bind_funds_number=params[:bind_funds_number]
        b.save
      end
      render :json => "s1".to_json
    else
      @fundproduct.update_attributes(:productid=>params[:productid],:productname=>params[:productname],:L2_typeid=>params[:L2_typeid],
                                    :L2_typename=>params[:L2_typename],:internet_product=>params[:internet_product],:institution=>params[:institution],
                                    :product_code=>params[:product_code],:min_purchase_account=>params[:min_purchase_account],:create_date=>params[:create_date],
                                    :fund_size=>params[:fund_size],:other_usage=>params[:other_usage],:official_link=>params[:official_link],:bind_funds_number=>params[:bind_funds_number])
      render :json => "s2".to_json
    end
  end

  def fundproductdeleteajax
    @fundproduct=Fund_product.find_by_id(params[:id])
    if @fundproduct!=nil
      if @fundproduct.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def risktypeconfig
    @typel2=Admin_asset_type_l2.all
    if params[:id]!="0"
      @risktype=Admin_risktolerance_type.find_by_id(params[:id])
    else
      @risktype=Admin_risktolerance_type.limit(1)
    end
  end

  def risktypeconfigajax
    @risktype=Admin_risktolerance_type.find_by_risk_typename(params[:risk_typename])
    if @risktype==nil
      Admin_risktolerance_type.new do |b|
        b.risk_typeid=params[:risk_typeid]
        b.risk_typename=params[:risk_typename]
        b.risk_brief_intro=params[:risk_brief_intro]
        b.risk_classicperson=params[:risk_classicperson]
        b.risk_spec_intro=params[:risk_spec_intro]
        b.risk_score_arrange=params[:risk_score_arrange]
        b.risk_type_products=params[:risk_type_products]
        b.risk_type_returnrate=params[:risk_type_returnrate]
        b.save
      end
      render :json => "s1".to_json
    else
      @risktype.update_attributes(:risk_typeid=>params[:risk_typeid],:risk_typename=>params[:risk_typename],:risk_brief_intro=>params[:risk_brief_intro],
                                    :risk_score_arrange=>params[:risk_score_arrange],:risk_type_products=>params[:risk_type_products],:risk_type_returnrate=>params[:risk_type_returnrate],
                                    :risk_classicperson=>params[:risk_classicperson],:risk_spec_intro=>params[:risk_spec_intro])
      render :json => "s2".to_json
    end
  end

  def risktypedeleteajax
    @risktype=Admin_risktolerance_type.find_by_id(params[:id])
    if @risktype!=nil
      if @risktype.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end
  def indicatorsconfig
    if params[:id]!="0"
      @indicators=Admin_finacialindicators.find_by_id(params[:id])
    else
      @indicators=Admin_finacialindicators.limit(1)
    end
  end

  def indicatorsconfigajax
    if params[:id]=="0"
      Admin_finacialindicators.new do |b|
        b.indicators_id=params[:indicators_id]
        b.indicators_names=params[:indicators_names]
        b.indicators_types=params[:indicators_types]
        b.indicators_defination=params[:indicators_defination]
        b.indicators_intro=params[:indicators_intro]
        b.indicators_recomn_max=params[:indicators_recomn_max]
        b.indicators_recomn_min=params[:indicators_recomn_min]
        b.remarks=params[:remarks]
        b.save
      end
      render :json => "s1".to_json
    else
      @indicators=Admin_finacialindicators.find_by_id(params[:id])
      @indicators.update_attributes(:indicators_id=>params[:indicators_id],:indicators_names=>params[:indicators_names],:indicators_types=>params[:indicators_types],
                                    :indicators_defination=>params[:indicators_defination],:indicators_intro=>params[:indicators_intro],:indicators_recomn_max=>params[:indicators_recomn_max],
                                    :indicators_recomn_min=>params[:indicators_recomn_min],:remarks=>params[:remarks])
      render :json => "s2".to_json
    end
  end

  def indicatorsdeleteajax
    @indicators=Admin_finacialindicators.find_by_id(params[:id])
    if @indicators!=nil
      if @indicators.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def moonliteconfig
    if params[:id]!="0"
      @moonlite=Admin_moonlite_type.find_by_id(params[:id])
    else
      @moonlite=Admin_moonlite_type.limit(1)
    end
  end

  def moonliteconfigajax
    if params[:id]=="0"
      Admin_moonlite_type.new do |b|
        b.typeid=params[:typeid]
        b.typename=params[:typename]
        b.type_intro=params[:type_intro]
        b.save
      end
      render :json => "s1".to_json
    else
      @moonlite=Admin_moonlite_type.find_by_id(params[:id])
      @moonlite.update_attributes(:typeid=>params[:typeid],:typename=>params[:typename],:type_intro=>params[:type_intro])
      render :json => "s2".to_json
    end
  end

  def moonlitedeleteajax
    @moonlite=Admin_moonlite_type.find_by_id(params[:id])
    if @moonlite!=nil
      if @moonlite.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def debtconfig
      if params[:id]!="0"
        @debttype=Admin_debt_type.find_by_id(params[:id])
      else
        @debttype=Admin_debt_type.limit(1)
      end
  end

  def debtconfigajax
    if params[:id]=="0"
      Admin_debt_type.new do |b|
        b.debt_typeid=params[:debt_typeid]
        b.debt_typename=params[:debt_typename]
        b.save
      end
      render :json => "s1".to_json
    else
      @debttype=Admin_debt_type.find_by_id(params[:id])
      @debttype.update_attributes(:debt_typeid=>params[:debt_typeid],:debt_typename=>params[:debt_typename])
      render :json => "s2".to_json
    end
  end

  def debtdeleteajax
    @debttype=Admin_debt_type.find_by_id(params[:id])
    if @debttype!=nil
      if @debttype.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def assetconfig
      if params[:id]!="0"
        @assettype=Admin_asset_type.find_by_id(params[:id])
      else
        @assettype=Admin_asset_type.limit(1)
      end
  end

  def assetconfigajax
    if params[:id]=="0"
      Admin_asset_type.new do |b|
        b.asset_typeid=params[:asset_typeid]
        b.asset_typename=params[:asset_typename]
        b.asset_type_L1=params[:asset_type_L1]
        b.asset_intro=params[:asset_intro]
        b.save
      end
      render :json => "s1".to_json
    else
      @assettype=Admin_asset_type.find_by_id(params[:id])
      @assettype.update_attributes(:asset_typeid=>params[:asset_typeid],:asset_typename=>params[:asset_typename],:asset_type_L1=>params[:asset_type_L1],:asset_intro=>params[:asset_intro])
      render :json => "s2".to_json
    end
  end

  def assetdeleteajax
    @assettype=Admin_asset_type.find_by_id(params[:id])
    if @assettype!=nil
      if @assettype.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def incomeannualconfig
      if params[:id]!="0"
        @incomeannual=Admin_income_type_annual.find_by_id(params[:id])
      else
        @incomeannual=Admin_income_type_annual.limit(1)
      end
  end

  def incomeannualconfigajax
    if params[:id]=="0"
      Admin_income_type_annual.new do |b|
        b.income_id=params[:income_id]
        b.income_name=params[:income_name]
        b.income_expect=params[:income_expect]
        b.save
      end
      render :json => "s1".to_json
    else
      @incomeannual=Admin_income_type_annual.find_by_id(params[:id])
      @incomeannual.update_attributes(:income_id=>params[:income_id],:income_name=>params[:income_name],:income_expect=>params[:income_expect])
      render :json => "s2".to_json
    end
  end

  def incomeannualdeleteajax
    @incomeannual=Admin_income_type_annual.find_by_id(params[:id])
    if @incomeannual!=nil
      if @incomeannual.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end
  def incomeconfig
      if params[:id]!="0"
        @incometype=Admin_income_type_month.find_by_id(params[:id])
      else
        @incometype=Admin_income_type_month.limit(1)
      end
  end

  def incomeconfigajax
    if params[:id]=="0"
      Admin_income_type_month.new do |b|
        b.income_id=params[:income_id]
        b.income_name=params[:income_name]
        b.income_intro=params[:income_intro]
        b.income_expect=params[:income_expect]
        b.save
      end
      render :json => "s1".to_json
    else
      @incometype=Admin_income_type_month.find_by_id(params[:id])
      @incometype.update_attributes(:income_id=>params[:income_id],:income_name=>params[:income_name],:income_intro=>params[:income_intro],:income_expect=>params[:income_expect])
      render :json => "s2".to_json
    end
  end

  def incomedeleteajax
    @incometype=Admin_income_type_month.find_by_id(params[:id])
    if @incometype!=nil
      if @incometype.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def expenseannualconfig
      if params[:id]!="0"
        @expenseannual=Admin_expense_type_annual.find_by_id(params[:id])
      else
        @expenseannual=Admin_expense_type_annual.limit(1)
      end
  end

  def expenseannualconfigajax
    if params[:id]=="0"
      Admin_expense_type_annual.new do |b|
        b.expense_id=params[:expense_id]
        b.expense_name=params[:expense_name]
        b.expense_expect=params[:expense_expect]
        b.save
      end
      render :json => "s1".to_json
    else
      @expenseannual=Admin_expense_type_annual.find_by_id(params[:id])
      @expenseannual.update_attributes(:expense_id=>params[:expense_id],:expense_name=>params[:expense_name],:expense_expect=>params[:expense_expect])
      render :json => "s2".to_json
    end
  end

  def expenseannualdeleteajax
    @expenseannual=Admin_expense_type_annual.find_by_id(params[:id])
    if @expenseannual!=nil
      if @expenseannual.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end
  def expenseconfig
      if params[:id]!="0"
        @expensetype=Admin_expense_type_month.find_by_id(params[:id])
      else
        @expensetype=Admin_expense_type_month.limit(1)
      end
  end

  def expenseconfigajax
    if params[:id]=="0"
      Admin_expense_type_month.new do |b|
        b.expense_id=params[:expense_id]
        b.expense_name=params[:expense_name]
        b.expense_intro=params[:expense_intro]
        b.expense_expect=params[:expense_expect]
        b.expense_type=params[:expense_type]
        b.save
      end
      render :json => "s1".to_json
    else
      @expensetype=Admin_expense_type_month.find_by_id(params[:id])
      @expensetype.update_attributes(:expense_id=>params[:expense_id],:expense_name=>params[:expense_name],:expense_intro=>params[:expense_intro],:expense_expect=>params[:expense_expect],:expense_type=>params[:expense_type])
      render :json => "s2".to_json
    end
  end

  def expensedeleteajax
    @expensetype=Admin_expense_type_month.find_by_id(params[:id])
    if @expensetype!=nil
      if @expensetype.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def methodconfig
      if params[:id]!="0"
        @methodology=Methodology.find_by_id(params[:id])
      else
        @methodology=Methodology.limit(1)
      end
  end

  def methodconfigajax
    if params[:id]=="0"
      Methodology.new do |b|
        b.mname=params[:mname]
        b.article=params[:article]
        b.picture=params[:picture]
        b.save
      end
      render :json => "s1".to_json
    else
      @methodology=Methodology.find_by_id(params[:id])
      @methodology.update_attributes(:mname=>params[:mname],:article=>params[:article],:picture=>params[:picture])
      render :json => "s2".to_json
    end
  end

  def methoddeleteajax
    @methodology=Methodology.find_by_id(params[:id])
    if @methodology!=nil
      if @methodology.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def pressconfig
      if params[:id]!="0"
        @press=Press.find_by_id(params[:id])
      else
        @press=Press.limit(1)
      end
  end

  def pressconfigajax
    if params[:id]=="0"
      Press.new do |b|
        b.pname=params[:pname]
        b.pdate=params[:pdate]
        b.pimg=params[:pimg]
        b.plink=params[:plink]
        b.save
      end
      render :json => "s1".to_json
    else
      @press=Press.find_by_id(params[:id])
      @press.update_attributes(:pname=>params[:pname],:pdate=>params[:pdate],:pimg=>params[:pimg],:plink=>params[:plink])
      render :json => "s2".to_json
    end
  end

  def pressdeleteajax
    @press=Press.find_by_id(params[:id])
    if @press!=nil
      if @press.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def paceconfig
      if params[:id]!="0"
        @pace=Pace.find_by_id(params[:id])
      else
        @pace=Pace.limit(1)
      end
  end

  def paceconfigajax
    if params[:id]=="0"
      Pace.new do |b|
        b.functionname=params[:functionname]
        b.introduce=params[:introduce]
        b.developtime=params[:developtime]
        b.ontime=params[:ontime]
        b.develop=params[:develop]
        b.auditor=params[:auditor]
        b.details=params[:details]
        b.save
      end
      render :json => "s1".to_json
    else
      @pace=Pace.find_by_id(params[:id])
      @pace.update_attributes(:functionname=>params[:functionname],:introduce=>params[:introduce],:developtime=>params[:developtime],:ontime=>params[:ontime],
                              :develop=>params[:develop],:auditor=>params[:auditor],:details=>params[:details])
      render :json => "s2".to_json
    end
  end

  def pacedeleteajax
    @pace=Pace.find_by_id(params[:id])
    if @pace!=nil
      if @pace.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def category1config
      if params[:id]!="0"
        @category1=Admin_asset_type_l1.find_by_id(params[:id])
      else
        @category1=Admin_asset_type_l1.limit(1)
      end
  end

  def category1configajax
    if params[:id]=="0"
      Admin_asset_type_l1.new do |b|
        b.L1_typeid=params[:L1_typeid]
        b.category=params[:category]
        b.save
      end
      render :json => "s1".to_json
    else
      @category1=Admin_asset_type_l1.find_by_id(params[:id])
      @category1.update_attributes(:L1_typeid=>params[:L1_typeid],:category=>params[:category])
      render :json => "s2".to_json
    end
  end

  def category1deleteajax
    @category1=Admin_asset_type_l1.find_by_id(params[:id])
    if @category1!=nil
      if @category1.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def category2config
      @category1=Admin_asset_type_l1.all
      if params[:id]!="0"
        @category2=Admin_asset_type_l2.find_by_id(params[:id])
        @probability=Loss_probability.find_all_by_typeid(@category2.L2_typeid)
        @max=Max_return_rate.find_all_by_typeid(@category2.L2_typeid)
      else
        @category2=Admin_asset_type_l2.limit(1)
        @probability=Loss_probability.limit(1)
        @max=Max_return_rate.limit(1)
      end
  end

  def category2configajax
    if params[:id]=="0"
      Admin_asset_type_l2.new do |b|
        b.L2_typeid=params[:L2_typeid]
        b.category=params[:category]
        b.risklevel=params[:risklevel]
        b.classify=params[:classify]
        b.ptype=params[:ptype]
        b.prisk=params[:prisk]
        b.returns=params[:returns]
        b.startvalue=params[:startvalue]
        b.averagerate=params[:averagerate]
        b.fluidvalue=params[:fluidvalue]
        b.volatilityvalue=params[:volatilityvalue]
        b.save
      end
      render :json => "s1".to_json
    else
      @category2=Admin_asset_type_l2.find_by_id(params[:id])
      @financial=Financial.find_all_by_category_and_classify(params[:category],params[:classify])
      for i in 0..@financial.size-1
        @financial[i].update_attributes(:risklevel=>params[:risklevel]);
      end
      @category2.update_attributes(:averagerate=>params[:averagerate],:L2_typeid=>params[:L2_typeid],:category=>params[:category],:risklevel=>params[:risklevel],:classify=>params[:classify],
                                   :ptype=>params[:ptype],:prisk=>params[:prisk],:returns=>params[:returns],:startvalue=>params[:startvalue],:fluidvalue=>params[:fluidvalue],:volatilityvalue=>params[:volatilityvalue])
      render :json => "s2".to_json
    end
  end

  def category2deleteajax
    @category2=Admin_asset_type_l2.find_by_id(params[:id])
    if @category2!=nil
      if @category2.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def financialconfig
      if params[:id]!="0"
        @financial=Financial.find_by_id(params[:id])
        @productcompany=Productcompany.find_all_by_pname(@financial.pname)
      else
        @financial=Financial.limit(1)
        @productcompany=Productcompany.limit(1)
      end
      @salescompany=Salescompany.all
      @hash={}
      @category=Admin_asset_type_l2.find_by_sql("select distinct category from admin_asset_type_L2")
      for i in 0..@category.size-1
         @category2=Admin_asset_type_l2.find_all_by_category(@category[i].category)
         for j in 0..@category2.size-1
           if j==0
             @cate='|'+@category2[j].classify
           else
             @cate=@cate+'|'+@category2[j].classify
           end
         end
         @hash.store(@category2[0].category,[i+1,@cate])
      end
  end

  def financialconfigajax
    @category2=Admin_asset_type_l2.find_by_category_and_classify(params[:category],params[:classify])
    @risklevel=@category2.risklevel
    if params[:id]=="0"
      Financial.new do |b|
        b.category=params[:category]
        b.pname=params[:pname]
        b.classify=params[:classify]
        b.trusts=params[:trusts]

        b.rate=params[:rate]
        b.rate1=params[:rate1]
        b.rate2=params[:rate2]
        b.rank=params[:rank]
        b.rank1=params[:rank1]
        b.rank2=params[:rank2]

        b.property=params[:property]
        b.bound=params[:bound]
        b.way=params[:way]

        b.startvalue=params[:startvalue]
        b.risklevel=@risklevel
        b.risktip=params[:risktip]
        b.pintroduction=params[:pintroduction]
        b.link=params[:link]
        b.investperiod=params[:investperiod]
        b.poundage=params[:poundage]
        b.productcode=params[:productcode]
        b.averrate=params[:averrate]
        b.level=params[:level]
        b.save
      end
      render :json => "s1".to_json
    else
      @financial=Financial.find_by_id(params[:id])
      @financial.update_attributes(:category=>params[:category],:pname=>params[:pname],:classify=>params[:classify],:trusts=>params[:trusts],:link=>params[:link],:productcode=>params[:productcode],:averrate=>params[:averrate],:level=>params[:level],
             :startvalue=>params[:startvalue],:risklevel=>@risklevel,:risktip=>params[:risktip],:pintroduction=>params[:pintroduction],:investperiod=>params[:investperiod],:poundage=>params[:poundage])
      if params[:classify]=='货币基金' && params[:property]=='互联网产品'
        @financial.update_attributes(:property=>params[:property],:bound=>params[:bound],:way=>params[:way])
      else
        @financial.update_attributes(:rate=>params[:rate],:rate1=>params[:rate1],:rate2=>params[:rate2],:rank=>params[:rank],:rank1=>params[:rank1],:rank2=>params[:rank2],:property=>'传统产品')
      end

      render :json => "s2".to_json
    end
  end

  def financialdeleteajax
    @financial=Financial.find_by_id(params[:id])
    if @financial!=nil
      if @financial.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def companyconfig
      if params[:id]!="0"
        @salescompany=Salescompany.find_by_id(params[:id])
      else
        @salescompany=Salescompany.limit(1)
      end
  end

  def companyconfigajax
    if params[:id]=="0"
      Salescompany.new do |b|
        b.fundname=params[:fundname]
        b.company=params[:company]
        b.capital=params[:capital]
        b.profile=params[:personalinfo]
        b.introduced=params[:introduced]
        b.logo=params[:logo]
        b.license=params[:license]
        b.guide=params[:guide]
        b.time=params[:time]
        b.assist=params[:assist]
        b.imglink=params[:imglink]
        b.videolink=params[:videolink]
        b.save
      end
      render :json => "s1".to_json
    else
      @salescompany=Salescompany.find_by_id(params[:id])
      @salescompany.update_attributes(:fundname=>params[:fundname],:company=>params[:company],:capital=>params[:capital],:personalinfo=>params[:personalinfo],:introduced=>params[:introduced],
                                      :logo=>params[:logo],:license=>params[:license],:guide=>params[:guide],:time=>params[:time],:assist=>params[:assist],:imglink=>params[:imglink],:videolink=>params[:videolink])
      render :json => "s2".to_json
    end
  end

  def companydeleteajax
    @salescompany=Salescompany.find_by_id(params[:id])
    if @salescompany!=nil
      if @salescompany.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def averageconfig
    if params[:id]!="0"
      @average=Average_return_rate.find_by_id(params[:id])
    else
      @average=Average_return_rate.limit(1)
    end
  end

  def averageconfigajax
    if params[:id]=="0"
      Average_return_rate.new do |p|
        p.typeid=params[:typeid]
        p.average_return_rate=params[:average_return_rate]
        p.years=params[:years]
        p.save
      end
      render :json => "s1".to_json
    else
      @average=Average_return_rate.find_by_id(params[:id])
      @average.update_attributes(:typeid=>params[:typeid],:average_return_rate=>params[:average_return_rate],:years=>params[:years])
      render :json => "s2".to_json
    end
  end

  def averagedeleteajax
    @average=Average_return_rate.find_by_id(params[:id])
    if @average!=nil
      if @average.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def maxconfigajax
    if params[:id]=="0"
      Max_return_rate.new do |p|
        p.typeid=params[:typeid]
        p.returnrate=params[:returnrate]
        p.years=params[:years]
        p.save
      end
      render :json => "s1".to_json
    else
      @max=Max_return_rate.find_by_id(params[:id])
      @max.update_attributes(:typeid=>params[:typeid],:returnrate=>params[:returnrate],:years=>params[:years])
      render :json => "s2".to_json
    end
  end

  def maxdeleteajax
    @max=Max_return_rate.find_by_id(params[:id])
    if @max!=nil
      if @max.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def lossconfigajax
    if params[:id]=="0"
      Loss_probability.new do |p|
        p.typeid=params[:typeid]
        p.probability=params[:probability]
        p.years=params[:years]
        p.save
      end
      render :json => "s1".to_json
    else
      @probability=Loss_probability.find_by_id(params[:id])
      @probability.update_attributes(:typeid=>params[:typeid],:probability=>params[:probability],:years=>params[:years])
      render :json => "s2".to_json
    end
  end

  def lossdeleteajax
    @probability=Loss_probability.find_by_id(params[:id])
    if @probability!=nil
      if @probability.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def poundageconfig
    if params[:id]!="0"
      @productcompany=Productcompany.find_by_id(params[:id])
    else
      @productcompany=Productcompany.limit(1)
    end
    @financial=Financial.all
    @salescompany=Salescompany.all
  end

  def poundageconfigajax
    if params[:id]=="0"
      Productcompany.new do |p|
        p.pname=params[:pname]
        p.fundname=params[:fundname]
        p.poundage=params[:poundage]
        p.link=params[:link]
        p.save
      end
      render :json => "s1".to_json
    else
      @productcompany=Productcompany.find_by_id(params[:id])
      @productcompany.update_attributes(:pname=>params[:pname],:fundname=>params[:fundname],:poundage=>params[:poundage],:link=>params[:link])
      render :json => "s2".to_json
    end
  end


  def poundagedeleteajax
    @productcompany=Productcompany.find_by_id(params[:id])
    if @productcompany!=nil
      if @productcompany.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def userconfig
    if params[:id]!="0"
      @webuser=Webuser.find_by_id(params[:id])
    end
  end

  def userlogout
    session[:webusername]=nil
    session[:qq]=nil
    render :json => "s".to_json
  end

  def  userconfigajax
    @webuser=Webuser.find_by_username(params[:username])
    if params[:password]!=nil
    password=encode(params[:password])
    end
    if params[:id]=="0"
      if @webuser==nil && params[:username]!="" && params[:username]!=nil
        Webuser.new do |w|
          w.username=params[:username]
          w.password=password
          w.tel=params[:tel]
          w.email=params[:email]
          w.save
        end

        Thread.new{
          if params[:ulogin]=="1"
          #  UserMailer.confirm(params[:username],params[:email],params[:tel],"新投资人首页注册").deliver
            UserMailer.welcome(params[:username],params[:email],"欢迎注册通天顺家庭理财").deliver
          end
        }
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    else
      @webuser.update_attributes(:email=>params[:email],:tel=>params[:tel])
      render :json => "s2".to_json
    end
  end

  def userajax
    @webuser=Webuser.find_by_username(params[:username])
    if @webuser!=nil
      render :json => "f".to_json
    else
      render :json => "s".to_json
    end
  end

  def userdeleteajax
    @webuser=Webuser.find(params[:id])
    if @webuser.destroy
      render :json => "s".to_json
    else
      render :json => "f".to_json
    end
  end


  def forgetpassword
    @webuser=Webuser.find_by_email(params[:email])
    password=encode("tongtianshun")
    if @webuser!=nil
      @webuser.update_attributes(:password=>password)
    else
      Webuser.new do |w|
        w.username=params[:email]
        w.password=password
        w.email=params[:email]
        w.save
      end
    end
    Thread.new{
        UserMailer.forgetpassword(params[:email],"修改密码").deliver
    }
    render :json => "s".to_json
  end

  def userlogin
    if params[:login]!='qq'
      session[:qq]=1
    else
      session[:qq]=2
    end
    @webuser=Webuser.find_by_username(params[:username])
    @userfinancedata=User_finance_data.find_by_username(params[:username])
    if @webuser!=nil
      if @webuser.password==encode(params[:password])
        if params[:weixincode]!=nil && params[:weixincode]!=""
          @weixins=Webuser.find_by_sql("select * from webuser where weixincode like '%"+params[:weixincode]+"%'")
          if @weixins.size>0
          @weixin=Webuser.find_by_username(@weixins[0].username)
          else
          @weixin=nil
          end
          if @weixin!=nil
            weixin=@weixin.weixincode.split(",")
            if weixin.size==1
            @weixin.update_attributes(:weixincode=>nil)
            else
              code=""
              for i in 0..weixin.size-1
                if weixin[i]!=params[:weixincode]
                  if i==0
                     code=weixin[i]
                  else
                    code=code+","+weixin[i]
                  end
                end
          end
              @weixin.update_attributes(:weixincode=>code)
            end
          end
          if @webuser.weixincode==nil
          @webuser.update_attributes(:weixincode=>params[:weixincode])
          else
            @webuser.update_attributes(:weixincode=>@webuser.weixincode+","+params[:weixincode])
          end
          session[:webusername]=@webuser.username
          render :json => "weixincode".to_json
        else
        if params[:organ]=='3'|| params[:organ]=='4'
          if  @webuser.username=="admin" || @webuser.username=="blog"
            session[:webusername]=@webuser.username
            render :json => "admin".to_json
          elsif @userfinancedata!=nil && @userfinancedata.risk_score!=nil
            session[:webusername]=@webuser.username
            render :json => "g1".to_json
          else
            session[:webusername]=@webuser.username
            render :json => "g2".to_json
          end
        else
          session[:webusername]=@webuser.username
          render :json => "s2".to_json
        end
        end
      else
        render :json => "f".to_json
      end
    else
      render :json => "f2".to_json
    end
  end

  def activityconfig
    if session[:webusername]!=nil
      @bloginfo=[]
      if params[:id]!="0"
        @activity=Activity.find_by_id(params[:id])
      end
    else
      redirect_to(:controller=>"home")
    end
  end

  def activityconfigajax
    if params[:id]=="0"
      Activity.new do |b|
        b.name=params[:name]
        b.naturef=params[:naturef]
        b.natures=params[:natures]
        b.organizer=params[:organizer]
        b.begintime=params[:begintime]
        b.endtime=params[:endtime]
        b.introduce=params[:introduce]
        b.result=params[:result]
        b.charge=params[:charge]
        b.address=params[:address]
        b.link=params[:link]
        b.reward=params[:reward]
        b.video=params[:video]
        b.show=params[:show]
        b.save
      end
      render :json => "s1".to_json

    else
      @activity=Activity.find_by_id(params[:id])
      @activity.update_attributes(:name=>params[:name],:naturef=>params[:naturef],:natures=>params[:natures],
                              :organizer=>params[:organizer],:begintime=>params[:begintime],:endtime=>params[:endtime],
                              :introduce=>params[:introduce],:result=>params[:result],:charge=>params[:charge],
                              :address=>params[:address],:link=>params[:link],:reward=>params[:reward],:video=>params[:video],:show=>params[:show])
      render :json => "s2".to_json
    end
  end

   def activitydeleteajax
     @activity=Activity.find_by_id(params[:id])
     if @activity!=nil
       if @activity.destroy
         render :json => "s".to_json
       else
         render :json => "f".to_json
       end
     end
   end

  def blogconfig
    if session[:webusername]!=nil
      @bloginfo=[]
      if params[:id]!="0"
        @blog=Blog.find_by_id(params[:id])
        @bloginfo[0]=@blog.btitle
        @bloginfo[1]=@blog.blname
        @bloginfo[2]=@blog.publishdate
        @bloginfo[3]=@blog.barticle
        @bloginfo[4]=@blog.bcolumn
        @bloginfo[5]=@blog.imagepath
        @bloginfo[6]=@blog.tag
      end
    else
      redirect_to(:controller=>"home")
    end
  end

  def blogconfigajax
    if params[:id]=="0"
      Blog.new do |b|
        b.btitle=params[:btitle]
        b.blname=params[:blname]
        b.publishdate=params[:publishdate]
        b.barticle=params[:barticle]
        b.bcolumn=params[:bcolumn]
        b.imagepath=params[:imagepath]
        b.tag=params[:tag]
        b.save
      end
      render :json => "s1".to_json

    else
      @blog=Blog.find_by_id(params[:id])
      @blog.update_attributes(:btitle=>params[:btitle],:blname=>params[:blname],:publishdate=>params[:publishdate],
                              :barticle=>params[:barticle],:bcolumn=>params[:bcolumn],:imagepath=>params[:imagepath],:tag=>params[:tag])
      render :json => "s2".to_json
    end
  end

  def blogdeleteajax
    @blog=Blog.find_by_id(params[:id])
    if @blog!=nil
      if @blog.destroy
        render :json => "s".to_json
      else
        render :json => "f".to_json
      end
    end
  end

  def upload_file(file)
    if !file.original_filename.empty?
      @filename=file.original_filename
      File.open("#{Rails.root}/app/assets/images/#{@filename}", "wb") do |f|
        f.write(file.read)
      end
      return @filename
    end
  end

  def get_file_name(filename)
    if !filename.nil?
      Time.now.strftime("%Y%m%d%H%M%S") + '_' + filename
    end
  end

  def save_file
    unless request.get?
      if filename=upload_file(params[:file]['file'])
        return filename
      end
    end
  end
  #==============================
  # 修改create方法：
  def create
    @photo = Photo.new(params[:photo])
    @filename=save_file   #调用save_file方法，返回文件名
    @photo.url="/images/#{@filename}"   #保存文件路径字段
    @photo.name=@filename   #保存文件名字段
    if @photo.save
      flash[:notice] = 'Photo was successfully created.'
      redirect_to "/assets/"+@filename
    else
      render :action => 'index'
    end
  end
end


require 'openssl'
require 'base64'
ALG = 'DES-EDE3-CBC'  #算法
KEY = "mZ4Wjs6L"  #8位密钥
DES_KEY = "nZ4wJs6L"

#加密
def encode(str)
  des = OpenSSL::Cipher::Cipher.new(ALG)
  des.pkcs5_keyivgen(KEY, DES_KEY)
  des.encrypt
  cipher = des.update(str)
  cipher << des.final
  return Base64.encode64(cipher) #Base64编码，才能保存到数据库
end

#解密
def decode(str)
  str = Base64.decode64(str)
  des = OpenSSL::Cipher::Cipher.new(ALG)
  des.pkcs5_keyivgen(KEY, DES_KEY)
  des.decrypt
  des.update(str) + des.final
end
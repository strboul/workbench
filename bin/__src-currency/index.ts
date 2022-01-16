import * as Datetime from "https://deno.land/std@0.91.0/datetime/mod.ts";
import * as Colors from "https://deno.land/std@0.121.0/fmt/colors.ts";

interface ICurrency {
  amount: string;
  from: string;
  to: string;
}

class Currency {
  public readonly amount: string;
  public readonly from: string;
  public readonly to: string;

  private rate!: number;
  private total!: number;

  constructor(args: ICurrency) {
    this.amount = args.amount;
    this.from = args.from;
    this.to = args.to;
  }

  async printResult(): Promise<void> {
    Log.info(`converting ${this.amount} ${this.from} ${this.to}`);
    await this.getConversionRate();
    this.calculateTotal();
    console.log(`conversion rate: ${this.rate}`);
    console.log(`total: ${this.total} ${this.to}`);
    this.saveToHistFile();
  }

  private async getConversionRate(): Promise<void> {
    const currStr: string = `${this.from}${this.to}`.toUpperCase();
    const result = await fetch(
      `https://query1.finance.yahoo.com/v8/finance/chart/${currStr}=X`,
    );
    const json = await result.json();
    const { regularMarketPrice } = json.chart.result[0].meta;
    this.rate = this.signDigits(regularMarketPrice, 4);
  }

  private calculateTotal(): void {
    let total: number = Number(this.amount) * this.rate;
    total = this.signDigits(total, 2);
    this.total = total;
  }

  private signDigits(num: number, digits: number): number {
    return Number(num.toFixed(digits));
  }

  private get histFilePath(): string {
    return `${Deno.env.get("HOME")}/.currency_hist.csv`;
  }

  private async saveToHistFile(): Promise<void> {
    const data = [
      Log.getTimestamp(),
      this.amount,
      this.from,
      this.to,
      this.rate,
      this.total,
    ];
    const line = data.join(",") + "\n";
    await Deno.writeTextFile(this.histFilePath, line, { append: true });
    Log.success(`saved to ${this.histFilePath}`);
  }
}

// FIXME if you write more deno bin, move this to a common utils module
class Log {
  static info(message: string) {
    console.log(Colors.yellow(Log.makeMessage(message)));
  }
  static success(message: string) {
    console.log(Colors.green(Log.makeMessage(message)));
  }
  static error(message: string) {
    console.log(Colors.red(Log.makeMessage(message)));
    console.log(Colors.red("Aborted."));
    Deno.exit(1);
  }
  static getTimestamp(): string {
    return Datetime.format(new Date(), "yyyy-MM-dd HH:mm:ss");
  }
  private static makeMessage(message: string): string {
    const timestamp = Log.getTimestamp();
    return `[${timestamp}] ${message}`;
  }
}

const parseArgs = () => {
  const [amount, from, to] = Deno.args;
  const args = { amount, from, to };
  return args;
};

const main = async () => {
  const args = parseArgs();
  const currency = new Currency(args);
  await currency.printResult();
};

main();

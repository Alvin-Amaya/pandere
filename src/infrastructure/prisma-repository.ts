import { IRepository } from "@/domain/repository";

export interface IDataModel<T> {
  findMany(args?: { where?: Record<string, any> }): Promise<T[]>;
  findUnique(args: { 
    where: { id: number }; 
    include?: Record<string, boolean | any>; 
  }): Promise<T | null>;
  create(args: { data: any }): Promise<T>;
  update(args: { where: { id: number }; data: any }): Promise<T>;
  delete(args: { where: { id: number } }): Promise<any>;
}


export class Repository<T> implements IRepository<T> {
  constructor(protected model: IDataModel<T>) { }

  async findById(id: number, include?: Record<string, boolean | any>): Promise<T | null> {
    return await this.model.findUnique({ where: { id }, include });
  }

  async getAll(): Promise<T[]> {
    return await this.model.findMany();
  }

  async create(item: Omit<T, "id">): Promise<T> {
    return await this.model.create({ data: item });
  }

  async update(id: number, item: Partial<Omit<T, "id">>): Promise<T> {
    return await this.model.update({
      where: { id },
      data: item,
    });
  }

  async delete(id: number): Promise<void> {
    await this.model.delete({ where: { id } });
  }
}
import { Service } from "./service";
import { Project, Skill } from "./types";

export class ProjectService extends Service<Project> {
    async getSkills(projectId: number): Promise<Skill[]> {
        const project = await this.repository.findById(projectId, {
            include: {
                project_has_skill: {
                    include: {
                        skill: true
                    }
                }
            }
        });

        if (!project) return [];
        const relations = (project as any).project_has_skill ?? [];
        return relations
            .map((ps: any) => ps.skill)
            .filter((skill: Skill | null) => skill !== null);
    }

    // async addSkill(projectId: number, skill: Skill): Promise<void> {
    //     const project = await this.repository.findById(projectId, {
    //         include: {
    //             project_has_skill: true
    //         }
    //     });

    //     if (!project) throw new Error("Project not found");

    //     const existingSkills = (project as any).project_has_skill ?? [];
    //     const skillExists = existingSkills.some(
    //         (ps: any) => ps.skillId === skill.id
    //     );

    //     if (!skillExists) {
    //         existingSkills.push({ projectId, skillId: skill.id });
    //         await this.repository.update(projectId, {
    //             project_has_skill: existingSkills
    //         });
    //     }
    // }
}
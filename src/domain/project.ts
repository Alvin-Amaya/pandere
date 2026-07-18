import { Service } from "./service";
import { Project, Skill } from "./types";

interface ProjectHasSkill {
    projectId: number;
    skillId: number;
    skill?: Skill | null;
}

interface OrganizationSummary {
    id: number;
    name: string;
}

interface ProjectDTO extends Project {
    project_has_skill?: ProjectHasSkill[];
    organization?: OrganizationSummary | null;
}

export class ProjectService extends Service<Project> {
    async getSkills(projectId: number): Promise<Skill[]> {
        const project = (await this.repository.findById(projectId, {
            include: {
                project_has_skill: {
                    include: {
                        skill: true
                    }
                }
            }
        })) as ProjectDTO;

        if (!project) return [];
        const relations = project.project_has_skill ?? [];
        return relations
            .map(ps => ps.skill)
            .filter((skill): skill is Skill => skill !== null);
    }

    async getAll(): Promise<ProjectDTO[]> {
        const projects = await this.repository.getAll({
            // include: {
                organization: true,
            // },
        });

        return projects.map((project) => ({
            ...project,
            // organization: project.organization_has_project?.[0]?.organization ?? null,
        }));
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